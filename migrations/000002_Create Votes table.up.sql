BEGIN;

-- Create votes table
CREATE TABLE IF NOT EXISTS votes
(
    id SERIAL PRIMARY KEY,
    user_id VARCHAR(255) NOT NULL,  -- Clerk user ID
    set_num VARCHAR(130) NOT NULL,  -- References sets table
    rating INTEGER NOT NULL CHECK (rating >= 1 AND rating <= 5),
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    
    -- Foreign key constraint
    CONSTRAINT fk_set
        FOREIGN KEY (set_num) 
        REFERENCES sets(set_num)
        ON DELETE CASCADE,
    
    -- Unique constraint to ensure one vote per user per set
    CONSTRAINT unique_user_set_vote
        UNIQUE (user_id, set_num)
);

-- Create index on set_num for faster aggregation queries
CREATE INDEX IF NOT EXISTS idx_votes_set_num ON votes(set_num);

-- Create index on user_id for faster user-specific queries
CREATE INDEX IF NOT EXISTS idx_votes_user_id ON votes(user_id);

-- Create a function to update the updated_at timestamp
CREATE OR REPLACE FUNCTION update_votes_updated_at()
RETURNS TRIGGER AS $$
BEGIN
    NEW.updated_at = CURRENT_TIMESTAMP;
    RETURN NEW;
END;
$$ LANGUAGE plpgsql;

-- Create trigger to automatically update updated_at
CREATE TRIGGER trigger_update_votes_updated_at
    BEFORE UPDATE ON votes
    FOR EACH ROW
    EXECUTE FUNCTION update_votes_updated_at();

COMMIT;
