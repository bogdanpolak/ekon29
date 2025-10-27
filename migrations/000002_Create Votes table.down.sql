BEGIN;

-- Drop trigger
DROP TRIGGER IF EXISTS trigger_update_votes_updated_at ON votes;

-- Drop function
DROP FUNCTION IF EXISTS update_votes_updated_at();

-- Drop indexes
DROP INDEX IF EXISTS idx_votes_user_id;
DROP INDEX IF EXISTS idx_votes_set_num;

-- Drop votes table
DROP TABLE IF EXISTS votes;

COMMIT;
