"""make created_at timezone-aware

Revision ID: b5e11b7ab2b5
Revises: cd3c99638d3f
Create Date: 2026-08-18 18:20:54.913541

"""
from typing import Sequence, Union

from alembic import op
import sqlalchemy as sa


# revision identifiers, used by Alembic.
revision: str = 'b5e11b7ab2b5'
down_revision: Union[str, Sequence[str], None] = 'cd3c99638d3f'
branch_labels: Union[str, Sequence[str], None] = None
depends_on: Union[str, Sequence[str], None] = None


def upgrade() -> None:
    """Upgrade schema."""
    op.execute("ALTER TABLE courses ALTER COLUMN created_at TYPE timestamptz USING created_at AT TIME ZONE 'UTC'")
    op.execute("ALTER TABLE videos ALTER COLUMN created_at TYPE timestamptz USING created_at AT TIME ZONE 'UTC'")


def downgrade() -> None:
    """Downgrade schema."""
    op.execute("ALTER TABLE courses ALTER COLUMN created_at TYPE timestamp WITHOUT TIME ZONE USING created_at AT TIME ZONE 'UTC'")
    op.execute("ALTER TABLE videos ALTER COLUMN created_at TYPE timestamp WITHOUT TIME ZONE USING created_at AT TIME ZONE 'UTC'")
