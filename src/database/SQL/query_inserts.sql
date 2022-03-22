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
("Create"), 
("Read"), 
("Update"), 
("Delete");   

INSERT INTO TABLAS_EXISTENTES(tabla) VALUES
("USUARIOS"), 
("MENSAJES_INQUIETUDES"), 
("ORDENES_COMPRA"), 
("ACCESORIOS"), 
("HISTORICO_CAMBIO_PRECIOS"),
("ORDENES_COMPRA_HAS_ACCESORIOS"),
("FACTURAS"), 
("HISTORICO_INGRESOS_GASTOS"),
("HISTORICO_CAMBIO_PRECIOS"); 

INSERT INTO TIPOS_MOVIMIENTO_FINANCIERO(movimiento) VALUES
('Ingreso por venta'), 
('Gasto por pago a proveedores'), 
('Gasto por devolución'); 

INSERT INTO ACCESORIOS (id_usuario_creacion, id_usuario_ultima_modificacion, nombre, descripcion, stock, precio_ultima_compra, precio_base, descuento, precio_final, ruta_imagen) VALUES
(1,1,"Rin cromado plateado 18in.","Juego de 4 Rines de 18 pulgadas con cromado de aleación de aluminio de alta resistencia (color plateado). Proporciona frenadas más eficiente, mejora la refrigeración de los discos de frenado, protege las suspensión del vehículo y mejora la apariencia del vehículo.",20,170000,2200000,5,2090000,"/Rin_cromado_plateado_18in.jpg"),
(1,1,"Rin cromado plateado 24in." ,"Juego de 4 Rines de 24 pulgadas con cromado de aleación de aluminio de alta resistencia (color plateado). Proporciona frenadas más eficiente, mejora la refrigeración de los discos de frenado, protege las suspensión del vehículo y mejora la apariencia del vehículo. ",20,1800000,2350000,5,2232500,"/Rin_cromado_plateado_24in.jpg"),
(1,1,"Rin cromado plateado 26in.","Juego de 4 Rines de 26 pulgadas con cromado de aleación de aluminio de alta resistencia (color plateado). Proporciona frenadas más eficiente, mejora la refrigeración de los discos de frenado, protege las suspensión del vehículo y mejora la apariencia del vehículo. ",20,1900000,2500000,5,2375000,"/Rin_cromado_plateado_26in.jpg"),
(1,1,"Rin cromado dorado 16in.","Juego de 4 Rines de 16 pulgadas con cromado de aleación de aluminio de alta resistencia (color dorado). Proporciona frenadas más eficiente, mejora la refrigeración de los discos de frenado, protege las suspensión del vehículo y mejora la apariencia del vehículo. ",20,1600000,1950000,5,1852500,"/Rin_cromado_dorado_16in.jpg"),
(1,1,"Rin cromado dorado 24in.","Juego de 4 Rines de 24 pulgadas con cromado de aleación de aluminio de alta resistencia (color dorado). Proporciona frenadas más eficiente, mejora la refrigeración de los discos de frenado, protege las suspensión del vehículo y mejora la apariencia del vehículo. ",20,1750000,2300000,5,2185000,"/Rin_cromado_dorado_24in.jpg"),
(1,1,"Cubierta negra para carro","Cubierta de tela negra impermeable para carros. Permite prevenir daños por rayos UV, polvo, nieve, escarcha, lluvia, etc. Se incluye estuche para guardar la cubierta. ",40,240000,320000,25,240000,"/Cubierta_negra_para_carro.jpg"),
(1,1,"Cubierta gris para carro","Cubierta de tela gris impermeable para carros. Permite prevenir daños por rayos UV, polvo, nieve, escarcha, lluvia, etc. Se incluye estuche para guardar la cubierta. ",40,240000,320000,25,240000,"/Cubierta_gris_para_carro.jpg"),
(1,1,"Tapete negro para carro","Tapete color nego de goma y tela absorbente para carros. Está hecho de polímero de goma ultra duradero. Protege el suelo del carro contra la humedad y el polvo, facilita la limpieza y es anti-deslizante. ",60,80000,120000,15,102000,"Tapete_negro_para_carro.jpt"),
(1,1,"Tapete rojo para carro","Tapete color rojo de goma y tela absorbente para carros. Está hecho de polímero de goma ultra duradero. Protege el suelo del carro contra la humedad y el polvo, facilita la limpieza y es anti-deslizante. ",30,80000,120000,15,102000,"Tapete_rojo_para_carro.jpg"),
(1,1,"Tapete café para carro","Tapete color café de goma y tela absorbente para carros. Está hecho de polímero de goma ultra duradero. Protege el suelo del carro contra la humedad y el polvo, facilita la limpieza y es anti-deslizante. ",20,75000,110000,15,93500,"Tapete_café_para_carro.jpg"),
(1,1,"Funda de tela para volante","Funda decorativa de tela para volante. Mejora la experiencia de conducción, añade personalización al interior del vehículo, protege las manos del contacto directo con volantes directos fríos o calientes y protege el volante original del desgaste. ",15,55000,80000,0,80000,"/Funda_de_tela_para_volante.jpg"),
(1,1,"Funda negra para volante","Funda decorativa de piel de PVC para volante. Mejora la experiencia de conducción, añade personalización al interior del vehículo, protege las manos del contacto directo con volantes directos fríos o calientes y protege el volante original del desgaste. ",30,100000,140000,0,140000,"/Funda_negra_para_volante.jpg"),
(1,1,"Funda de cuero azul para volante","Funda decorativa de cuero tintado azul para volante. Mejora la experiencia de conducción, añade personalización al interior del vehículo, protege las manos del contacto directo con volantes directos fríos o calientes y protege el volante original del desgaste. ",30,120000,180000,0,180000,"/Funda_de_cuero_azul_para_volante.jpg"),
(1,1,"Dados decorativos para interior","Dados de peluche decorativos para espejo retrovisor de carro. Hechos de tela de piel sintética suave y con costuras de alta calidad.  ",20,40000,75000,20,60000,"/Dados_decorativios_para_interior.jpg"),
(1,1,"Tapizado negro para asiento","Tapizado color negro para asientos. Hecho de cuero sintético impermeable y a prueba de los rayos solares y las bajas temperaturas. Permite comodidas a los pasajeros y facilita la limpieza del vehículo.",50,240000,280000,10,252000,"/Tapizado_negro_para_asiento.jpg"),
(1,1,"Tapizado gris para asiento","Tapizado color gris para asientos. Hecho de cuero sintético impermeable y a prueba de los rayos solares y las bajas temperaturas. Permite comodidas a los pasajeros y facilita la limpieza del vehículo.",30,240000,280000,10,252000,"/Tapizado_gris_para_asiento.jpg"),
(1,1,"Tapizado rojo para asiento","Tapizado color rojo para asientos. Hecho de cuero sintético impermeable y a prueba de los rayos solares y las bajas temperaturas. Permite comodidas a los pasajeros y facilita la limpieza del vehículo.",50,280000,320000,20,256000,"/Tapizado_rojo_para_asiento.jpg"),
(1,1,"Polarizado trasero de 14%","Película polarizada para la parte trasera del vehículo. Permite pasar el 14% de la luz, cumpliento con las regulaciones nacionales. Permite aumentar la privacidad y conservar la temperatura del vehículo al bloquear los rayos solares.",20,380000,420000,5,399000,"/Polarizado_trasero_14%.jpg"),
(1,1,"Polarizado trasero de 35%","Película polarizada para la parte trasera del vehículo. Permite pasar el 35% de la luz, cumpliento con las regulaciones nacionales. Permite aumentar la privacidad y conservar la temperatura del vehículo al bloquear los rayos solares.",40,280000,320000,5,304000,"/Polarizado_trasero_35%.jpg"),
(1,1,"Polarizado trasero de 50%","Película polarizada para la parte trasera del vehículo. Permite pasar el 50% de la luz, cumpliento con las regulaciones nacionales. Permite aumentar la privacidad y conservar la temperatura del vehículo al bloquear los rayos solares.",40,270000,310000,5,294500,"/Polarizado_trasero_50%.jpg"),
(1,1,"Polarizado delantero de 70%","Película polarizada para la parte delantera del vehículo. Permite pasar el 70% de la luz, cumpliento con las regulaciones nacionales sin evitar la visibilidad. Permite aumentar la privacidad y conservar la temperatura del vehículo al bloquear los rayos solares.",50,340000,380000,5,361000,"/Polarizado_delantero_70%.jpg"),
(1,1,"Polarizado lateral de 55%","Película polarizada para la parte lateral del vehículo. Permite pasar el 55% de la luz, cumpliento con las regulaciones. Permite aumentar la privacidad y conservar la temperatura del vehículo al bloquear los rayos solares.",40,270000,310000,5,294500,"/Polarizado_lateral_55%.jpg"),
(1,1,"Polarizado lateral de 70%","Película polarizada para la parte lateral del vehículo. Permite pasar el 70% de la luz, cumpliento con las regulaciones. Permite aumentar la privacidad y conservar la temperatura del vehículo al bloquear los rayos solares.",30,230000,270000,5,256500,"/Polarizado_lateral_70%.jpg"),
(1,1,"Asiento pequeño para bebé","Silla de poliéster acolchada para bebés. Permite a los bebés descansar de manera segura y cómoda en el viaje. Peso máximo recomendado de 30Kg. La silla es fácil de transportar y trasladar gracias a su tamaño y peso.",15,240000,360000,15,306000,"/Asiento_pequeño_para_bebé.jpg"),
(1,1,"Asiento mediano para niños","Silla acolchada de tamaño mediano hecha de poliéster para niños. Permite a los niños descansar de manera segura y cómoda en el viaje. Peso máximo recomendado de 40Kg. La silla es fácil de transportar y trasladar gracias a su tamaño y peso.",10,280000,380000,15,323000,"/Asiento_mediano_para_niños.jpg"),
(1,1,"Asiento grande para niños","Silla acolchada de tamaño grande hecha de poliéster para niños. Permite a los niños descansar de manera segura y cómoda en el viaje. Peso máximo recomendado de 55Kg",10,320000,400000,15,340000,"/Asiento_grande_para_niños.jpg"),
(1,1,"Manija cromada para puerta","Manija decorativa cromada color plateado para las puertas laterales. Hecha de aleación de aluminio de alta resistencia e inoxidable" ,40,95000,120000,20,96000,"/Manija_cromada_para_puerta.jpg"),
(1,1,"Manija clásica para puerta","Manija decorativa clásica color plateado para las puertas laterales. Hecha de acero inoxidable" ,40,90000,110000,20,88000,"/Manija_clásica_para_puerta.jpg"),
(1,1,"Manija decorativa puño de acero","Manija decorativa con forma de puño color plateado para las puertas laterales. Hecha de acero inoxidable" ,20,90000,110000,20,88000,"/Manija_decorativa_puño_de_acero_para_puerta.jpg"),
(1,1,"Calcomanías dibujos animados","Calcomanías decorativas de dibujos animados. Material resistente al agua y pegamento duradero que se adhiere al material del carro.",40,40000,65000,15,55250,"/Calcomanías_dibujos_animados.jpg"),
(1,1,"Calcomaías urbanas variadas","Calcomanías decorativas de temática urbana variada. Material resistente al agua y pegamento duradero que se adhiere al material del carro.",40,40000,65000,15,55250,"/Calcomanías_urbanas_variadas.jpg"),
(1,1,"Cromado para luces traseras","Detalle cromado para luces traseras. Hecho de aleación de aluminio de alta resistencia inoxidable.",20,180000,220000,0,220000,"/Cromado_para_luces_delanteras.jpg"),
(1,1,"Cromado para luces delanteras","Detalle cromado para luces delanteras. Hecho de aleación de aluminio de alta resistencia inoxidable.",20,190000,220000,0,220000,"/Cromado_para_luces_traseras.jpg"),
(1,1,"Cromado para espejo izquierdo","Detalle cromado para espejo lateral izquierdo. Hecho de aleación de aluminio de alta resistencia inoxidable.",20,120000,160000,0,160000,"/Cromado_para_espejo_izquierdo.jpg"),
(1,1,"Cromado para espejo derecho","Detalle cromado para espejo lateral derecho. Hecho de aleación de aluminio de alta resistencia inoxidable.",20,120000,160000,0,160000,"/Cromado_para_espejo_derecho.jpg"),
(1,1,"Cromado para volante 1","Estilo acabado cromado para volante número 1. Hecho de aleación de aluminio de alta resistencia resistente a las altas temperaturas y los rayos solares. Da un estilo premium al interior del vehículo.",30,180000,220000,15,187000,"/Cromado_para_volante_1.jpg"),
(1,1,"Cromado para volante 2","Estilo acabado cromado y azul para volante número 2. Hecho de aleación de aluminio de alta resistencia resistente a las altas temperaturas y los rayos solares. Da un estilo premium al interior del vehículo.",20,180000,220000,15,187000,"/Cromado_para_volante_2.jpg"),
(1,1,"Cromado para volante 3","Estilo acabado cromado y negro para volante número 3. Hecho de aleación de aluminio de alta resistencia resistente a las altas temperaturas y los rayos solares. Da un estilo premium al interior del vehículo.",30,180000,220000,15,187000,"/Cromado_para_volante_3.jpg"),
(1,1,"Antena de radio decorativa","Antena de radio funcional y decorativa para el exterior del carro. Premite mejorar la recepción de la señal de radio y da un toque clásico y personalizado al vehículo",20,40000,75000,12,66000,"/Antena_de_radio_decorativa.jpg"),
(1,1,"Pantalla gps estilo 1","Pantalla GPS funcional estilo 1. Permite ubicarse a través de google maps (Requiere un dispositivo con conexión a internet o datos). También permite guardar ubicaciones preferidas y calcular la mejor ruta al destino.",20,180000,240000,10,216000,"/Pantalla_gps_estilo_1.jpg"),
(1,1,"Pantalla gps estilo 2","Pantalla GPS funcional estilo 2. Permite ubicarse a través de google maps (Requiere un dispositivo con conexión a internet o datos). También permite guardar ubicaciones preferidas, calcular la mejor ruta al destino y asistencia guiada por voz.",40,280000,360000,10,324000,"/Pantalla_gps_estilo_2.jpg"),
(1,1,"Soporte de celular para carro 1","Soporte de plástico para celular. Existen diferentes tamaños y colores, para diferentes necesidades y gustos. Permite manejar con seguridad, ya que evita tener que ocupar las manos en sostener el teléfono y no obstruye la visión. ",30,10000,25000,20,20000,"/Soporte_de_celular_para_carro_1"),
(1,1,"Cámara delantera para carro 1","Cámara filmadora para carro. Permite hasta 32 horas de grabación contínua en calidad HD con el uso de batería, aunque tambíen pemite grabar en calidad SD y Full HD. Se adapta automáticamente a condiciones de poca luz y posee almacenamiento inicial de 250GB (Extensible a 2TB mediante el uso de tarjetas externas)",20,460000,580000,10,522000,"/Cámara_delantera_para_carro_1"),
(1,1,"Cámara delantera para carro 2","Cámara filmadora para carro. Permite hasta 16 horas de grabación contínua en calidad HD con el uso de batería, aunque tambíen pemite grabar en calidad SD y Full HD. Se adapta automáticamente a condiciones de poca luz y posee almacenamiento inicial de 100GB (Extensible a 1TB mediante el uso de tarjetas externas)",20,380000,460000,10,414000,"/Cámara_delantera_para_carro_2.jpg"),
(1,1,"Pantalla para asiengo trasero","Pantalla para asiento trasero de carro, permite reproducir canciones, películas y videos almacenados en memorias USB o tarjetas SD. Compatible con aplicaciones de la PlayStore para Android 5.0 en adelante",30,285000,360000,0,360000,"/Pantalla_para_asiento_trasero.jpg"),
(1,1,"Altavoces de graves para carro","Par de altavoces potenciadores de graves para carro. Compatibles con audio Stereo y conectores 3,5mm. Ofrecen un audio nítido y graves mejorados con un subwoofer de 4W ",20,165000,260000,15,221000,"/Altavoces_de_graves_para_carro.jpg"),
(1,1,"Altavoz bluethooth para carro", "Altavoz bluethooth para carro. Se instala en la parte lateral del vehículo, ofrece un sonido nítido y acepta conexiones de Bluethooth 4.0 en adelante",30,145000,240000,15,204000,"/Altavoz_bluethooth_para_carro.jpg"),
(1,1,"Rack portaequipaje superior para carro 1","Rack portaequipaje abierto hecho de aluminio resistente al sol y la lluvia. Permite una capacidad de carga de hasta 120KG y su tamaño es adaptable para diferentes tipos de vehículos y equipaje",20,275000,320000,10,288000,"/Rack_portaquipaje_superior_para_carro_1.jpg"),
(1,1,"Rack portaequipaje superior para carro 2","Rack portaequipaje cerrado hecho de aluminio y plástico duro resistentes al sol y la lluvia. Permite una capacidad de carga de hasta 60KG y su tamaño es adaptable para diferentes tipos de vehículos y equipaje",20,245000,290000,10,261000,"/Rack_portaquipaje_superior_para_carro_2.jpg"),
(1,1,"Asiento de carro para mascotas","Asiento acolchado para mascotas. Guarda la temperatura a pesar de los rayos solares y  permite un viaje cómo y seguro para las mascotas. Posee alfombrillas en la parte inferior para mayor comodidad y permite fácil lavado",20,125000,160000,15,136000,"/Asiento_de_carro_para_mascotas.jpg"); 

SELECT * FROM TIPOS_TRANSACCION; 
SELECT * FROM TABLAS_EXISTENTES; 

SELECT * FROM ACCESORIOS; 
SELECT * FROM HISTORICO_CAMBIO_PRECIOS; 
SELECT * FROM HISTORICO_INGRESOS_GASTOS; 

SELECT * FROM USUARIOS; 
SELECT * FROM SESSION_USER_DATA; 
SELECT * FROM TIPOS_USUARIO; 
SELECT * FROM TIPOS_ESTADO_CUENTA; 

SELECT * FROM MENSAJES_INQUIETUDES; 

SELECT * FROM LOGS; 
SELECT * FROM LOGS_PRETTY; 

SELECT * FROM ORDENES_COMPRA;  
SELECT * FROM ORDENES_COMPRA_HAS_ACCESORIOS;
SELECT * FROM ORDER_SUMMARY; 
SELECT * FROM ORDER_SUMMARY_PRETTY; 

SELECT * FROM SESSION_USER_DATA; 

SELECT * FROM HISTORICO_FACTURAS; 
SELECT id_factura, id_orden, JSON_PRETTY(productos) 'productos' FROM HISTORICO_FACTURAS; 
SELECT * FROM BILL_DETAILS_PRETTY; 

