DROP DATABASE IF EXISTS INTEGRADOR_LOCAL; 
CREATE DATABASE INTEGRADOR_LOCAL; 
USE INTEGRADOR_LOCAL; 

CREATE TABLE TIPOS_USUARIO(
	codigo_tipo_usuario INT UNSIGNED AUTO_INCREMENT NOT NULL PRIMARY KEY, 
    tipo_usuario VARCHAR(64) NOT NULL COMMENT 'El usuario puede ser administrador, trabajador, cliente o socio'
); 

CREATE TABLE TIPOS_ESTADO_CUENTA(
	codigo_estado_cuenta INT UNSIGNED AUTO_INCREMENT NOT NULL PRIMARY KEY, 
    estado_cuenta VARCHAR(64) NOT NULL COMMENT 'La cuenta puede encontrarse activa, inactiva o fuera de servicio' 
); 

CREATE TABLE USUARIOS(
	id_usuario INT UNSIGNED AUTO_INCREMENT NOT NULL PRIMARY KEY, 
    nombre VARCHAR(255) NOT NULL COMMENT 'Se almacena el nombre completo para las personas naturales y la razón social para las empresas del consorcio', 
    identificacion VARCHAR(24) NOT NULL UNIQUE COMMENT 'Se almacena la cédula o documento de identificación para las personas naturales y el NIT para las empresas del consorcio', 
    correo_electronico VARCHAR(255) NOT NULL UNIQUE, 
    direccion VARCHAR(255) NOT NULL, 
    telefono VARCHAR(12) NOT NULL, 
    aceptacion_terminos TINYINT(1) NOT NULL COMMENT 'Aceptación por parte del usuario del tratamiento de sus datos personales para beneficio de la empresa y el consorcio', 
    contraseña VARCHAR(255) NOT NULL, 
    codigo_tipo_usuario INT UNSIGNED NOT NULL DEFAULT 1,
    codigo_estado_cuenta INT UNSIGNED NOT NULL DEFAULT 1, 
    id_usuario_creacion INT UNSIGNED NULL DEFAULT NULL REFERENCES USUARIOS(id_usuario), 
    id_usuario_ultima_modificacion INT UNSIGNED NULL DEFAULT NULL REFERENCES USUARIOS(id_usuario), 
    
    CONSTRAINT fk_usuarios_tipos_usuarios FOREIGN KEY (codigo_tipo_usuario) REFERENCES TIPOS_USUARIO(codigo_tipo_usuario), 
    CONSTRAINT fk_usuarios_tipos_estado_cuenta FOREIGN KEY (codigo_estado_cuenta) REFERENCES TIPOS_ESTADO_CUENTA(codigo_estado_cuenta),
    
    INDEX usuarios_nombre(nombre), 
    INDEX usuarios_correo_electronico(correo_electronico), 
    INDEX usuarios_id(id_usuario), 
    INDEX usuarios_codigo_tipo_usuaruio(codigo_tipo_usuario), 
    INDEX usuarios_codigo_estado_cuenta(codigo_estado_cuenta)
); 

CREATE TABLE TIPOS_TRANSACCION(
	codigo_tipo_transaccion INT UNSIGNED AUTO_INCREMENT NOT NULL PRIMARY KEY, 
    tipo_transaccion VARCHAR(64) NOT NULL COMMENT 'Creaate, Read, Update o Delete'
); 

CREATE TABLE TABLAS_EXISTENTES(
	codigo_tabla INT UNSIGNED AUTO_INCREMENT NOT NULL PRIMARY KEY, 
    tabla VARCHAR(64) NOT NULL COMMENT 'Tablas existentes en la base de datos a las que se les hace seguimiento a través de los logs'
); 

CREATE TABLE LOGS(
	id_transaccion INT UNSIGNED AUTO_INCREMENT NOT NULL PRIMARY KEY, 
    fecha_transaccion TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP, 
    estado_anterior JSON NULL DEFAULT NULL,
    estado_nuevo JSON NULL DEFAULT NULL, 
    codigo_tipo_transaccion INT UNSIGNED NOT NULL,
    codigo_tabla_modificada INT UNSIGNED NOT NULL, 
    id_usuario_responsable INT UNSIGNED NULL DEFAULT NULL,
    
    CONSTRAINT fk_logs_tipo_transaccion FOREIGN KEY (codigo_tipo_transaccion) REFERENCES TIPOS_TRANSACCION(codigo_tipo_transaccion), 
    CONSTRAINT fk_logs_tabla_modificada FOREIGN KEY (codigo_tabla_modificada) REFERENCES TABLAS_EXISTENTES(codigo_tabla),
    CONSTRAINT fk_logs_usuarios FOREIGN KEY (id_usuario_responsable) REFERENCES USUARIOS(id_usuario),
    
    INDEX logs_fecha_transaccion(fecha_transaccion), 
    INDEX logs_tipo_transaccion(codigo_tipo_transaccion), 
    INDEX logs_tabla_modificada(codigo_tabla_modificada)
)
ENGINE = 'MyISAM'; 

CREATE TABLE TIPO_ESTADO_MENSAJE(
	codigo_estado_mensaje INT UNSIGNED AUTO_INCREMENT NOT NULL PRIMARY KEY, 
    estado_mensaje VARCHAR(64) NOT NULL COMMENT 'El mensaje puede enviado o resuelto'
); 

CREATE TABLE MENSAJES_INQUIETUDES(
	id_mensaje INT UNSIGNED AUTO_INCREMENT NOT NULL PRIMARY KEY, 
    nombre_remitente VARCHAR(255) NOT NULL, 
    correo_remitente VARCHAR(255) NOT NULL, 
    texto_mensaje VARCHAR(324) NOT NULL, 
    codigo_estado_mensaje INT UNSIGNED NOT NULL DEFAULT 1, 
    id_usuario_ultima_modificacion INT UNSIGNED NULL DEFAULT NULL, 
    
    CONSTRAINT fk_mensajes_tipo_estado_mensaje FOREIGN KEY (codigo_estado_mensaje) REFERENCES TIPO_ESTADO_MENSAJE(codigo_estado_mensaje), 
    CONSTRAINT fk_mensajes_usuario_modificacion FOREIGN KEY (id_usuario_ultima_modificacion) REFERENCES USUARIOS(id_usuario), 
    
    INDEX mensajes_inquietudes_nombre(nombre_remitente), 
    INDEX mensajes_inquietudes_correo(correo_remitente)
); 

CREATE TABLE TIPO_ESTADO_COMPRA(
	codigo_estado_compra INT UNSIGNED AUTO_INCREMENT NOT NULL PRIMARY KEY, 
    estado_compra VARCHAR(64) NOT NULL COMMENT 'La orden de compra puede tener estado Enviada y Recibida'
); 

CREATE TABLE ACCESORIOS(
	id_accesorio INT UNSIGNED AUTO_INCREMENT NOT NULL PRIMARY KEY, 
    is_active TINYINT(1) UNSIGNED NOT NULL DEFAULT 1, 
    nombre VARCHAR(64) NOT NULL UNIQUE, 
    descripcion VARCHAR(324) NOT NULL, 
    stock INT UNSIGNED NOT NULL, 
    precio_ultima_compra DECIMAL(12,2) NOT NULL COMMENT 'Precio al que la emrpesa compró el accesorio a los proveedores', 
    precio_base DECIMAL(12,2) NOT NULL COMMENT 'Precio inicial del artículo sin descuento', 
    descuento TINYINT UNSIGNED NOT NULL COMMENT 'Porcentaje actual de descuento', 
    precio_final DECIMAL(12,2) NOT NULL COMMENT 'Precio_base - precio_base*descuento', 
    unidades_vendidas INT UNSIGNED NULL DEFAULT 0, 
    ruta_imagen VARCHAR(255) NOT NULL COMMENT 'Parte final de la ruta en las carpetas del servidor HTTPS',
	id_usuario_creacion INT UNSIGNED NOT NULL, 
    id_usuario_ultima_modificacion INT UNSIGNED NOT NULL, 
    
    CONSTRAINT FOREIGN KEY fk_accesorios_usuario_creacion (id_usuario_creacion) REFERENCES USUARIOS(id_usuario), 
    CONSTRAINT FOREIGN KEY fk_accesorios_usuario_modificacion (id_usuario_ultima_modificacion) REFERENCES USUARIOS(id_usuario), 
    
    INDEX accesorios_nombre(nombre), 
    INDEX accesorios_descuento(descuento), 
    INDEX accesorios_unidades_vendidas(unidades_vendidas), 
    INDEX accesorios_isActive(is_active)
); 

CREATE TABLE HISTORICO_CAMBIO_PRECIOS(
	id_registro_cambio INT UNSIGNED AUTO_INCREMENT NOT NULL PRIMARY KEY, 
    fecha_cambio TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP, 
    precio_asignado DECIMAL(12,2) NOT NULL COMMENT 'Nuevo precio asignado al artículo', 
    id_accesorio INT UNSIGNED NOT NULL, 
	id_usuario_responsable INT UNSIGNED NOT NULL,
    
    CONSTRAINT FOREIGN KEY fk_historico_precios_modificador (id_usuario_responsable) REFERENCES USUARIOS(id_usuario), 
    CONSTRAINT fk_historico_cambio_precios_accesorios FOREIGN KEY (id_accesorio) REFERENCES ACCESORIOS(id_accesorio), 
    
    INDEX historico_cambio_precios_id_accesorio(id_accesorio)
)
ENGINE = 'MyISAM'; 

CREATE TABLE ORDENES_COMPRA(
	id_orden INT UNSIGNED AUTO_INCREMENT NOT NULL PRIMARY KEY,
    id_cliente INT UNSIGNED NOT NULL, 
    id_vendedor INT UNSIGNED NULL DEFAULT NULL, 
    fecha_compra TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP, 
    codigo_estado_compra INT UNSIGNED NOT NULL DEFAULT 1, 
	id_usuario_creacion INT UNSIGNED NOT NULL, 
    id_usuario_ultima_modificacion INT UNSIGNED NOT NULL, 
    
    CONSTRAINT fk_ordenes_compra_usuarios FOREIGN KEY (id_cliente) REFERENCES USUARIOS(id_usuario), 
    CONSTRAINT fk_ordenes_compra_vendedor FOREIGN KEY (id_vendedor) REFERENCES USUARIOS(id_usuario), 
    CONSTRAINT fk_ordenes_compra_estado_compra FOREIGN KEY (codigo_estado_compra) REFERENCES TIPO_ESTADO_COMPRA(codigo_estado_compra), 
	CONSTRAINT FOREIGN KEY fk_ordenes_compra_usuario_creacion (id_usuario_creacion) REFERENCES USUARIOS(id_usuario), 
    CONSTRAINT FOREIGN KEY fk_ordenes_compra_usuario_modificacion (id_usuario_ultima_modificacion) REFERENCES USUARIOS(id_usuario), 
    
    INDEX ordenes_compra_id_orden(id_orden), 
    INDEX ordenes_compra_codigo_estado(codigo_estado_compra), 
    INDEX ordenes_compra_id_cliente(id_cliente), 
    INDEX ordenes_compra_fecha_compra(fecha_compra)
); 

CREATE TABLE HISTORICO_FACTURAS(
	id_factura INT UNSIGNED AUTO_INCREMENT NOT NULL PRIMARY KEY, 
    id_orden INT UNSIGNED NOT NULL, 
    productos JSON,
	id_usuario_creacion INT UNSIGNED NOT NULL, 
    id_usuario_ultima_modificacion INT UNSIGNED NOT NULL, 
    
    CONSTRAINT FOREIGN KEY fk_factura_usuario_creacion (id_usuario_creacion) REFERENCES USUARIOS(id_usuario), 
    CONSTRAINT FOREIGN KEY fk_factura_usuario_modificacion (id_usuario_ultima_modificacion) REFERENCES USUARIOS(id_usuario), 
    CONSTRAINT fk_facturas_ordenes FOREIGN KEY (id_factura) REFERENCES ORDENES_COMPRA(id_orden)
); 

CREATE TABLE TIPOS_MOVIMIENTO_FINANCIERO(
	codigo_movimiento INT UNSIGNED AUTO_INCREMENT NOT NULL PRIMARY KEY, 
    movimiento VARCHAR(255) NOT NULL COMMENT 'Los movimientos pueden ser Ingreso por venta, Gasto por pago a proveedores o Gasto por devolución'
); 

CREATE TABLE HISTORICO_INGRESOS_GASTOS(
	id_registro_ingreso_gasto INT UNSIGNED AUTO_INCREMENT NOT NULL PRIMARY KEY, 
    fecha_movimiento TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP, 
    codigo_tipo_movimiento INT UNSIGNED NOT NULL, 
    valor_movimiento DECIMAL(12,2) NOT NULL, 
	id_usuario_creacion INT UNSIGNED NOT NULL, 
    id_usuario_ultima_modificacion INT UNSIGNED NOT NULL, 
    
    INDEX historico_ingresos_gastos_tipo_movimiento(codigo_tipo_movimiento),
    INDEX historico_ingresos_gastos_valor_movimiento(valor_movimiento), 
    
	CONSTRAINT FOREIGN KEY fk_historico_ingresos_gastos_usuario_creacion (id_usuario_creacion) REFERENCES USUARIOS(id_usuario), 
    CONSTRAINT FOREIGN KEY fk_historico_ingresos_gastos_usuario_modificacion (id_usuario_ultima_modificacion) REFERENCES USUARIOS(id_usuario), 
    CONSTRAINT FOREIGN KEY fk_historico_ingresos_gastos_tipo_movimiento (codigo_tipo_movimiento) REFERENCES TIPOS_MOVIMIENTO_FINANCIERO(codigo_movimiento)
); 

CREATE TABLE ORDENES_COMPRA_HAS_ACCESORIOS(
	id_orden INT UNSIGNED NOT NULL, 
    id_accesorio INT UNSIGNED NOT NULL, 
    cantidad_venta SMALLINT UNSIGNED NOT NULL,
    precio_base DECIMAL(12,2) NOT NULL COMMENT 'Precio del accesorio en el momento de la venta multiplicado por la cantidad del accesorio comprada', 
	descuento_venta DECIMAL(12,2) NOT NULL COMMENT 'Descuento, en pesos colombianos, aplicado a la venta del accesorio', 
    impuestos_venta DECIMAL(12,2) NOT NULL COMMENT 'IVA generado por la venta del accesorio',
    precio_final DECIMAL(12,2) NOT NULL COMMENT 'Precio final teniendo en cuenta impuestos y descuentos del accesorio',
    id_usuario_creacion INT UNSIGNED NOT NULL, 
    id_usuario_ultima_modificacion INT UNSIGNED NOT NULL,
    
    CONSTRAINT fk_ordenes_compra_has_accesorios_id_orden FOREIGN KEY (id_orden) REFERENCES ORDENES_COMPRA(id_orden), 
    CONSTRAINT fk_ordenes_compra_has_accesorios_id_accesorio FOREIGN KEY (id_accesorio) REFERENCES ACCESORIOS(id_accesorio), 
	CONSTRAINT FOREIGN KEY fk_ordenes_compra_has_accesorios_usuario_creacion (id_usuario_creacion) REFERENCES USUARIOS(id_usuario), 
    CONSTRAINT FOREIGN KEY fk_ordenes_compra_has_accesorios_usuario_modificacion (id_usuario_ultima_modificacion) REFERENCES USUARIOS(id_usuario), 
    
    INDEX ordenes_compra_has_accesorios_id_orden(id_orden), 
    INDEX ordenes_compra_has_accesorios_id_accesorio(id_accesorio)
); 

CREATE TABLE CARRITO_COMPRAS(
    id_usuario INT UNSIGNED NOT NULL, 
    id_accesorio INT UNSIGNED NOT NULL, 
    cantidad_accesorio INT UNSIGNED NOT NULL,
    
    CONSTRAINT fk_carrito_usuarios FOREIGN KEY (id_usuario) REFERENCES USUARIOS(id_usuario), 
    CONSTRAINT fk_carrito_accesorio FOREIGN KEY (id_accesorio) REFERENCES ACCESORIOS(id_accesorio), 
    
    INDEX carrito_user(id_usuario)
)COMMENT = 'TABLA PARA EL MANEJO DEL CARRITO DE COMPRAS DESDE EL APLICATIVO WEB'; 