INSERT INTO boats (name, registration_no, capacity_kg) VALUES
('Маяк', 'RF-001', 5000),
('Волна', 'RF-002', 3500)
ON CONFLICT DO NOTHING;
INSERT INTO crews (name, captain) VALUES
('Северная команда', 'Иванов И.И.'),
('Морской патруль', 'Петров П.П.')
ON CONFLICT DO NOTHING;
INSERT INTO fish_types (name, latin_name) VALUES
('Треска', 'Gadus morhua'),
('Сельдь', 'Clupea harengus'),
('Скумбрия', 'Scomber scombrus')
ON CONFLICT DO NOTHING;
