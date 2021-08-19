from datetime import datetime
import string
import random

import aioredis
from typing import Optional

from fastapi import FastAPI
from pydantic import BaseModel, Field

redis = aioredis.from_url("redis://localhost:6379")
app = FastAPI()


def generate_token(size=6, chars=string.ascii_uppercase + string.ascii_lowercase + string.digits):
    return ''.join(random.choice(chars) for _ in range(size))


class Paste(BaseModel):
    ttl: int = 300
    body: str
    created_at: datetime = Field(datetime.now())
    updated_at: datetime = Field(datetime.now())
    permalink: str = Field(generate_token())


@app.post("/p")
async def save_paste(paste: Paste):
    await redis.set(paste.permalink, paste.json(), ex=paste.ttl)
    return True


@app.get("/p/{paste_name}")
async def get_paste(paste_name: str) -> Paste:
    try:
        paste = Paste.parse_raw(await redis.get(paste_name))
        return paste
    except Exception as e:
        print(e)
