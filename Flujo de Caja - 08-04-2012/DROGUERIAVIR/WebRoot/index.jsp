<%@ page language="java" import="java.util.*" pageEncoding="ISO-8859-1"%>
<%
String path = request.getContextPath();
String basePath = request.getScheme()+"://"+request.getServerName()+":"+request.getServerPort()+path+"/";
%>

<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN">
<html>
  <head>
    <base href="<%=basePath%>">
    
    <title>My JSP 'index.jsp' starting page</title>
	<meta http-equiv="pragma" content="no-cache">
	<meta http-equiv="cache-control" content="no-cache">
	<meta http-equiv="expires" content="0">    
	<meta http-equiv="keywords" content="keyword1,keyword2,keyword3">
	<meta http-equiv="description" content="This is my page">
	<!--
	<link rel="stylesheet" type="text/css" href="styles.css">
	-->
  </head>
  
  <body>
    <h1>LA DROGUERIA VIRTUAL</h1> <br>
   
    <h2>A continuación usted podrá escoger alguna de las opciones según su Rol:</h2>
    <br><h1>Administrador</h1><br><a href="Administrador/GestionMed.jspx">Sigue este enlace </a>
     <a href="Cliente/TiendaVirtual.jspx"> </a><br>
     <br><h1>Cliente o Gestion del Carrito de Compras</h1><a href="GestionCarrito/GestionCar.jspx">Sigue este enlace </a>
  </body>
</html>
