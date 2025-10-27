BEGIN;

DO $$
BEGIN
    -- Create themes table
    CREATE TABLE IF NOT EXISTS themes
    (
        id SERIAL PRIMARY KEY,
        theme_name VARCHAR(255) NOT NULL,
        sub_theme VARCHAR(255)
    );
    
    -- Add theme_id column to sets table
    ALTER TABLE sets ADD COLUMN IF NOT EXISTS theme_id INTEGER;

    -- Migrate existing themes to the new Themes table
    -- Extract unique themes from sets table and split theme_name and sub_theme by ' - '
    INSERT INTO themes (theme_name, sub_theme)
    SELECT DISTINCT
        SPLIT_PART(theme, ' - ', 1) AS theme_name,
        CASE
            WHEN POSITION(' - ' IN theme) > 0 THEN SPLIT_PART(theme, ' - ', 2)
            ELSE NULL
        END AS sub_theme
    FROM sets
    WHERE theme IS NOT NULL
    ORDER BY theme_name, sub_theme;

    RAISE NOTICE 'Migration completed successfully';

EXCEPTION
    WHEN OTHERS THEN
        RAISE NOTICE 'Migration failed: %', SQLERRM;
        RAISE;
END $$;

COMMIT;



-- Update `sets` table to reference `themes` table
-- Match the original theme string by concatenating theme_name and sub_theme back together
UPDATE sets
SET theme_id = themes.id
FROM themes
WHERE sets.theme = CONCAT(themes.theme_name, ' - ', themes.sub_theme) 
    AND sets.theme_id IS NULL;

-- Fill missing theme values for rows that have theme_id assigned
-- Reconstruct the theme string from the themes table
UPDATE sets
SET theme = CASE
    WHEN themes.sub_theme IS NOT NULL THEN CONCAT(themes.theme_name, ' - ', themes.sub_theme)
    ELSE themes.theme_name
END
FROM themes
WHERE sets.theme_id = themes.id
    AND (sets.theme IS NULL OR sets.theme = '');

