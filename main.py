from datetime import datetime, timedelta
import string
import random
import os

import aioredis

from typing import Optional
from fastapi import FastAPI
from pydantic import BaseModel, Field
from fastapi.middleware.cors import CORSMiddleware

REDIS_URI = os.environ.get("REDIS_URI", "redis://localhost:6379")

redis = aioredis.from_url(REDIS_URI)
app = FastAPI()
origins = [
    "http://localhost.tiangolo.com",
    "https://localhost.tiangolo.com",
    "http://localhost",
    "http://localhost:8080",
]
app.add_middleware(
    CORSMiddleware,
    allow_origins=["*"],
    allow_credentials=True,
    allow_methods=["*"],
    allow_headers=["*"],
)


def generate_token(size=6, chars=string.ascii_uppercase + string.ascii_lowercase + string.digits):
    return ''.join(random.choice(chars) for _ in range(size))


class Paste(BaseModel):
    ttl: int = 300
    body: str
    created_at: Optional[datetime] = None
    updated_at: Optional[datetime] = None
    deleted_at: Optional[datetime] = None
    permalink: Optional[str] = None


@app.post("/paste/")
async def save_paste(paste: Paste):
    if paste.permalink:
        loaded_paste = Paste.parse_raw(await redis.get(paste.permalink))
        if loaded_paste:
            loaded_paste.body = paste.body
            now = datetime.now()
            loaded_paste.updated_at = now
            loaded_paste.deleted_at = now + timedelta(0, await redis.ttl(loaded_paste.permalink))
            paste = loaded_paste
    else:
        paste.permalink = generate_token()
        now = datetime.now()
        paste.created_at = now
        paste.updated_at = now
        paste.deleted_at = now + timedelta(0, paste.ttl)

    await redis.set(paste.permalink, paste.json(), ex=paste.ttl)
    return paste


@app.get("/paste/{paste_name}")
async def get_paste(paste_name: str) -> Paste:
    try:
        paste = Paste.parse_raw(await redis.get(paste_name))
        return paste
    except Exception as e:
        print(e)


@app.get("/ping")
async def get_paste() -> str:
    return "OK"
