-- phpMyAdmin SQL Dump
-- version 5.0.2
-- https://www.phpmyadmin.net/
--
-- Servidor: 127.0.0.1
-- Tiempo de generación: 20-03-2021 a las 10:29:54
-- Versión del servidor: 10.4.14-MariaDB
-- Versión de PHP: 7.4.10

SET SQL_MODE = "NO_AUTO_VALUE_ON_ZERO";
START TRANSACTION;
SET time_zone = "+00:00";


/*!40101 SET @OLD_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT */;
/*!40101 SET @OLD_CHARACTER_SET_RESULTS=@@CHARACTER_SET_RESULTS */;
/*!40101 SET @OLD_COLLATION_CONNECTION=@@COLLATION_CONNECTION */;
/*!40101 SET NAMES utf8mb4 */;

--
-- Base de datos: `escuela`
--

-- --------------------------------------------------------

--
-- Estructura Stand-in para la vista `administrador`
-- (Véase abajo para la vista actual)
--
CREATE TABLE `administrador` (
`ID_Admin` int(11)
,`Nombre` varchar(150)
,`Apellido` varchar(150)
,`Username` varchar(100)
,`Password` varchar(150)
);

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `administradores`
--

CREATE TABLE `administradores` (
  `ID_Admin` int(11) NOT NULL,
  `Nombre` varchar(150) NOT NULL,
  `Apellido` varchar(150) NOT NULL,
  `Username` varchar(100) NOT NULL,
  `Password` varchar(150) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

--
-- Volcado de datos para la tabla `administradores`
--

INSERT INTO `administradores` (`ID_Admin`, `Nombre`, `Apellido`, `Username`, `Password`) VALUES
(1, 'Admin', 'Admin', 'Admin', 'Admin');

-- --------------------------------------------------------

--
-- Estructura Stand-in para la vista `alumno`
-- (Véase abajo para la vista actual)
--
CREATE TABLE `alumno` (
`ID_Alumno` int(11)
,`Nombre` varchar(150)
,`Apellido` varchar(100)
,`Username` varchar(20)
,`Password` varchar(150)
);

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `alumnos`
--

CREATE TABLE `alumnos` (
  `ID_Alumno` int(11) NOT NULL,
  `Nombre` varchar(150) NOT NULL,
  `Apellido` varchar(100) NOT NULL,
  `Username` varchar(20) NOT NULL,
  `Password` varchar(150) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

--
-- Volcado de datos para la tabla `alumnos`
--

INSERT INTO `alumnos` (`ID_Alumno`, `Nombre`, `Apellido`, `Username`, `Password`) VALUES
(1, 'Mayra', 'Gomez', 'Z17020069', '12345'),
(2, 'Carlos', 'Vargas', 'Z17020048', '12345');

-- --------------------------------------------------------

--
-- Estructura Stand-in para la vista `calificacion`
-- (Véase abajo para la vista actual)
--
CREATE TABLE `calificacion` (
`ID_Materia` int(11)
,`ID_Maestro` int(11)
,`ID_Alumno` int(11)
,`Calificacion` varchar(10)
);

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `calificaciones`
--

CREATE TABLE `calificaciones` (
  `ID_Materia` int(11) NOT NULL,
  `ID_Maestro` int(11) NOT NULL,
  `ID_Alumno` int(11) NOT NULL,
  `Calificacion` varchar(10) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

-- --------------------------------------------------------

--
-- Estructura Stand-in para la vista `maestro`
-- (Véase abajo para la vista actual)
--
CREATE TABLE `maestro` (
`ID_Maestro` int(11)
,`Nombre` varchar(150)
,`Apellido` varchar(150)
,`Username` varchar(100)
,`Password` varchar(150)
);

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `maestros`
--

CREATE TABLE `maestros` (
  `ID_Maestro` int(11) NOT NULL,
  `Nombre` varchar(150) NOT NULL,
  `Apellido` varchar(150) NOT NULL,
  `Username` varchar(100) NOT NULL,
  `Password` varchar(150) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

--
-- Volcado de datos para la tabla `maestros`
--

INSERT INTO `maestros` (`ID_Maestro`, `Nombre`, `Apellido`, `Username`, `Password`) VALUES
(1, 'Estrella', 'Gonzales', 'Estrella1', '12345');

-- --------------------------------------------------------

--
-- Estructura Stand-in para la vista `materia`
-- (Véase abajo para la vista actual)
--
CREATE TABLE `materia` (
`ID_Materia` int(11)
,`Nombre_Materia` varchar(150)
,`ID_Maestro` int(11)
,`ID_Alumno` int(11)
);

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `materias`
--

CREATE TABLE `materias` (
  `ID_Materia` int(11) NOT NULL,
  `Nombre_Materia` varchar(150) NOT NULL,
  `ID_Maestro` int(11) NOT NULL,
  `ID_Alumno` int(11) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

-- --------------------------------------------------------

--
-- Estructura para la vista `administrador`
--
DROP TABLE IF EXISTS `administrador`;

CREATE ALGORITHM=UNDEFINED DEFINER=`root`@`localhost` SQL SECURITY DEFINER VIEW `administrador`  AS  select `administradores`.`ID_Admin` AS `ID_Admin`,`administradores`.`Nombre` AS `Nombre`,`administradores`.`Apellido` AS `Apellido`,`administradores`.`Username` AS `Username`,`administradores`.`Password` AS `Password` from `administradores` ;

-- --------------------------------------------------------

--
-- Estructura para la vista `alumno`
--
DROP TABLE IF EXISTS `alumno`;

CREATE ALGORITHM=UNDEFINED DEFINER=`root`@`localhost` SQL SECURITY DEFINER VIEW `alumno`  AS  select `alumnos`.`ID_Alumno` AS `ID_Alumno`,`alumnos`.`Nombre` AS `Nombre`,`alumnos`.`Apellido` AS `Apellido`,`alumnos`.`Username` AS `Username`,`alumnos`.`Password` AS `Password` from `alumnos` ;

-- --------------------------------------------------------

--
-- Estructura para la vista `calificacion`
--
DROP TABLE IF EXISTS `calificacion`;

CREATE ALGORITHM=UNDEFINED DEFINER=`root`@`localhost` SQL SECURITY DEFINER VIEW `calificacion`  AS  select `calificaciones`.`ID_Materia` AS `ID_Materia`,`calificaciones`.`ID_Maestro` AS `ID_Maestro`,`calificaciones`.`ID_Alumno` AS `ID_Alumno`,`calificaciones`.`Calificacion` AS `Calificacion` from `calificaciones` ;

-- --------------------------------------------------------

--
-- Estructura para la vista `maestro`
--
DROP TABLE IF EXISTS `maestro`;

CREATE ALGORITHM=UNDEFINED DEFINER=`root`@`localhost` SQL SECURITY DEFINER VIEW `maestro`  AS  select `maestros`.`ID_Maestro` AS `ID_Maestro`,`maestros`.`Nombre` AS `Nombre`,`maestros`.`Apellido` AS `Apellido`,`maestros`.`Username` AS `Username`,`maestros`.`Password` AS `Password` from `maestros` ;

-- --------------------------------------------------------

--
-- Estructura para la vista `materia`
--
DROP TABLE IF EXISTS `materia`;

CREATE ALGORITHM=UNDEFINED DEFINER=`root`@`localhost` SQL SECURITY DEFINER VIEW `materia`  AS  select `materias`.`ID_Materia` AS `ID_Materia`,`materias`.`Nombre_Materia` AS `Nombre_Materia`,`materias`.`ID_Maestro` AS `ID_Maestro`,`materias`.`ID_Alumno` AS `ID_Alumno` from `materias` ;

--
-- Índices para tablas volcadas
--

--
-- Indices de la tabla `administradores`
--
ALTER TABLE `administradores`
  ADD PRIMARY KEY (`ID_Admin`);

--
-- Indices de la tabla `alumnos`
--
ALTER TABLE `alumnos`
  ADD PRIMARY KEY (`ID_Alumno`);

--
-- Indices de la tabla `calificaciones`
--
ALTER TABLE `calificaciones`
  ADD KEY `ID_Materia` (`ID_Materia`),
  ADD KEY `ID_Maestro` (`ID_Maestro`),
  ADD KEY `ID_Alumno` (`ID_Alumno`);

--
-- Indices de la tabla `maestros`
--
ALTER TABLE `maestros`
  ADD PRIMARY KEY (`ID_Maestro`);

--
-- Indices de la tabla `materias`
--
ALTER TABLE `materias`
  ADD PRIMARY KEY (`ID_Materia`),
  ADD KEY `ID_Alumno` (`ID_Alumno`),
  ADD KEY `ID_Maestro` (`ID_Maestro`) USING BTREE;

--
-- AUTO_INCREMENT de las tablas volcadas
--

--
-- AUTO_INCREMENT de la tabla `administradores`
--
ALTER TABLE `administradores`
  MODIFY `ID_Admin` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=2;

--
-- AUTO_INCREMENT de la tabla `alumnos`
--
ALTER TABLE `alumnos`
  MODIFY `ID_Alumno` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=3;

--
-- AUTO_INCREMENT de la tabla `maestros`
--
ALTER TABLE `maestros`
  MODIFY `ID_Maestro` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=2;

--
-- AUTO_INCREMENT de la tabla `materias`
--
ALTER TABLE `materias`
  MODIFY `ID_Materia` int(11) NOT NULL AUTO_INCREMENT;

--
-- Restricciones para tablas volcadas
--

--
-- Filtros para la tabla `calificaciones`
--
ALTER TABLE `calificaciones`
  ADD CONSTRAINT `Alumno` FOREIGN KEY (`ID_Alumno`) REFERENCES `alumnos` (`ID_Alumno`),
  ADD CONSTRAINT `Maestro` FOREIGN KEY (`ID_Maestro`) REFERENCES `maestros` (`ID_Maestro`),
  ADD CONSTRAINT `Materia` FOREIGN KEY (`ID_Materia`) REFERENCES `materias` (`ID_Materia`);

--
-- Filtros para la tabla `materias`
--
ALTER TABLE `materias`
  ADD CONSTRAINT `Alumnos` FOREIGN KEY (`ID_Alumno`) REFERENCES `alumnos` (`ID_Alumno`),
  ADD CONSTRAINT `Maestros` FOREIGN KEY (`ID_Maestro`) REFERENCES `maestros` (`ID_Maestro`);
COMMIT;

/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
