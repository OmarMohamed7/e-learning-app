from pydantic import BaseModel


class Instructor(BaseModel):
    id: str
    name: str
