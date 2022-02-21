INSERT INTO TIPOS_USUARIO(tipo_usuario) VALUES
("Cliente"), 
("Socio"),
("Trabajador"),  
("Administrador"); 

INSERT INTO TIPOS_ESTADO_CUENTA(estado_cuenta) VALUES
("Activo"), 
("Inactivo"), 
("Fuera de servicio"); 

INSERT INTO TIPO_ESTADO_MENSAJE(estado_mensaje) VALUES
("Enviado"), 
("Resuelto");  

INSERT INTO TIPO_ESTADO_COMPRA(estado_compra) VALUES
("En tránsito"), 
("Recibido");  

INSERT INTO TIPOS_TRANSACCION(tipo_transaccion) VALUES 
("Insert"), 
("Update"), 
("Delete"), 
("Read");   

INSERT INTO TABLAS_EXISTENTES(tabla) VALUES
("USUARIOS"), 
("MENSAJES_INQUIETUDES"), 
("ORDENES_COMPRA"), 
("ACCESORIOS"), 
("HISTORICO_CAMBIO_PRECIOS"); 

INSERT INTO ACCESORIOS (nombre, descripcion, stock, precio_base, descuento, precio_final, ruta_imagen) VALUES
("Rin cromado plateado 18in","Juego de 4 Rines de 18 pulgadas con cromado de aleación de aluminio de alta resistencia (color plateado). Proporciona frenadas más eficiente, mejora la refrigeración de los discos de frenado, protege las suspensión del vehículo y mejora la apariencia del vehículo.",20,2200000,5,2090000,"/Rin_cromado_plateado_18in.jpg"),
("Rin cromado plateado 24in" ,"Juego de 4 Rines de 24 pulgadas con cromado de aleación de aluminio de alta resistencia (color plateado). Proporciona frenadas más eficiente, mejora la refrigeración de los discos de frenado, protege las suspensión del vehículo y mejora la apariencia del vehículo. ",20,2350000,5,2232500,"/Rin_cromado_plateado_24in.jpg"),
("Rin cromado plateado 26in","Juego de 4 Rines de 26 pulgadas con cromado de aleación de aluminio de alta resistencia (color plateado). Proporciona frenadas más eficiente, mejora la refrigeración de los discos de frenado, protege las suspensión del vehículo y mejora la apariencia del vehículo. ",20,2500000,5,2375000,"/Rin_cromado_plateado_26in.jpg"),
("Rin cromado dorado 16in","Juego de 4 Rines de 16 pulgadas con cromado de aleación de aluminio de alta resistencia (color dorado). Proporciona frenadas más eficiente, mejora la refrigeración de los discos de frenado, protege las suspensión del vehículo y mejora la apariencia del vehículo. ",20,1995000,5,1895250,"/Rin_cromado_dorado_16in.jpg"),
("Rin cromado dorado 24in","Juego de 4 Rines de 24 pulgadas con cromado de aleación de aluminio de alta resistencia (color dorado). Proporciona frenadas más eficiente, mejora la refrigeración de los discos de frenado, protege las suspensión del vehículo y mejora la apariencia del vehículo. ",20,2300000,5,2185000,"/Rin_cromado_dorado_24in.jpg"),
("Cubierta negra para carro","Cubierta de tela negra impermeable para carros. Permite prevenir daños por rayos UV, polvo, nieve, escarcha, lluvia, etc. Se incluye estuche para guardar la cubierta. ",40,320000,25,240000,"/Cubierta_negra_para_carro.jpg"),
("Cubierta gris para carro","Cubierta de tela gris impermeable para carros. Permite prevenir daños por rayos UV, polvo, nieve, escarcha, lluvia, etc. Se incluye estuche para guardar la cubierta. ",40,320000,25,240000,"/Cubierta_gris_para_carro.jpg"),
("Funda de tela para volante","Funda decorativa de tela para volante. Mejora la experiencia de conducción, añade personalización al interior del vehículo, protege las manos del contacto directo con volantes directos fríos o calientes y protege el volante original del desgaste. ",15,100000,0,100000,"/Funda_de_tela_para_volante.jpg"),
("Funda negra para volante","Funda decorativa de piel de PVC para volante. Mejora la experiencia de conducción, añade personalización al interior del vehículo, protege las manos del contacto directo con volantes directos fríos o calientes y protege el volante original del desgaste. ",30,140000,0,140000,"/Funda_negra_para_volante.jpg"),
("Funda de cuero azul para volante","Funda decorativa de cuero tintado azul para volante. Mejora la experiencia de conducción, añade personalización al interior del vehículo, protege las manos del contacto directo con volantes directos fríos o calientes y protege el volante original del desgaste. ",30,180000,0,180000,"/Funda_de_cuero_azul_para_volante.jpg"),
("Dados decorativos para interior","Dados de peluche decorativos para espejo retrovisor de carro. Hechos de tela de piel sintética suave y con costuras de alta calidad.  ",20,75000,20,60000,"/Dados_decorativios_para_interior.jpg"),
("Asiento pequeño para bebé","Silla de poliéster acolchada para bebés. Permite a los bebés descansar de manera segura y cómoda en el viaje. Peso máximo recomendado de 30Kg. La silla es fácil de transportar y trasladar gracias a su tamaño y peso.",15,360000,15,306000,"/Asiento_pequeño_para_bebé.jpg"),
("Asiento mediano para niños","Silla acolchada de tamaño mediano hecha de poliéster para niños. Permite a los niños descansar de manera segura y cómoda en el viaje. Peso máximo recomendado de 40Kg. La silla es fácil de transportar y trasladar gracias a su tamaño y peso.",10,380000,0,380000,"/Asiento_mediano_para_niños.jpg"),
("Asiento grande para niños","Silla acolchada de tamaño grande hecha de poliéster para niños. Permite a los niños descansar de manera segura y cómoda en el viaje. Peso máximo recomendado de 55Kg",10,400000,0,400000,"/Asiento_grande_para_niños.jpg"); 

SELECT * FROM ACCESORIOS; 
SELECT * FROM TIPOS_USUARIO; 
SELECT * FROM TIPOS_ESTADO_CUENTA; 
SELECT * FROM USUARIOS; 
SELECT * FROM MENSAJES_INQUIETUDES; 
SELECT * FROM LOGS; 
SELECT * FROM HISTORICO_CAMBIO_PRECIOS; 

