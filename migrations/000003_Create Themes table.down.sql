UPDATE sets
SET theme = CASE 
    WHEN themes.sub_theme IS NOT NULL THEN CONCAT(themes.theme_name, ' - ', themes.sub_theme)
    ELSE themes.theme_name
END
FROM themes
WHERE sets.theme_id = themes.id AND (sets.theme IS NULL OR sets.theme = '');

DROP TABLE IF EXISTS themes;
ALTER TABLE sets DROP COLUMN IF EXISTS theme_id;
