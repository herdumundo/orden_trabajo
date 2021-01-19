<%@ Page Language="C#" AutoEventWireup="true"  %>

<!DOCTYPE html>

 <html lang="en">
 
<head>
    <meta content="width=device-width, initial-scale=1" name="viewport"/>
     <% @Import Namespace="WebApplication1.boot"%>
     <%
               if (Session["nombre_usuario"] == null)
    {
         Response.Redirect("login.aspx");
       
    } 
     String nombre_usuario= Session["nombre_usuario"].ToString();
     String perfil = Session["perfil"].ToString();
     String id_usuario = Session["id_usuario"].ToString();

    
     %>
  <!--<script type="text/javascript" src="fallas.js"></script>
  <link href="grilla.css" rel="stylesheet" />
  <script type="text/javascript" src="grilla.js"></script>-->

  <title>MAEHARA S.A.A.C.I.</title>
    <link href="vendor/bootstrap/css/bootstrap.min.css" rel="stylesheet">
    <link href="vendor/font-awesome/css/font-awesome.min.css" rel="stylesheet" type="text/css">
    <link href="vendor/datatables/dataTables.bootstrap4.css" rel="stylesheet">
    <link href="css/sb-admin.css" rel="stylesheet">
    <link href="css/sweetalert.css" rel="stylesheet" /> 
    <link href="estilos/estilo_calendario.css" rel="stylesheet" />
    <link href="estilos/css/grilla.css" rel="stylesheet" />
    <link rel="stylesheet" href="css/bootstrap4-toggle.css">
    <link rel="stylesheet" href="doc/stylesheet.css">
    <link rel="stylesheet" href="css/bootstrap4-toggle.css">
    <link href="css/inputmask.css" rel="stylesheet" />  
    <link href="css/acordeon_estilo.css" rel="stylesheet" />
    <link href="js/sweetalert2.scss"/>
    <link href="css/animate.css" rel="stylesheet" />
    <link href="libreria_calendario/themes/main.css" rel="stylesheet" />
    <link href="libreria_calendario/themes/default.css" rel="stylesheet" id="theme_base" />
    <link href="libreria_calendario/themes/default.date.css" rel="stylesheet" id="theme_date" />  

 
</head>



<body onload="login('<%=perfil %>')">
 
       <div id="div_index">  

        </div>
  
<div class="spinner" style="display:none" id="loading">
  <div class="rect1"></div>
  <div class="rect2"></div>
  <div class="rect3"></div>
  <div class="rect4"></div>
  <div class="rect5"></div>
</div>

 
        <script src="vendor/jquery/jquery.min.js"></script>
        <script src="vendor/bootstrap/js/bootstrap.min.js" type="text/javascript"></script>
        <script src="vendor/jquery-easing/jquery.easing.min.js"></script>
        <script src="js/grilla_2.js?v=1.0.3"></script>
        <script src="js/grilla.js?v=1.0.3"></script>
        <script src="vendor/chart.js/Chart.min.js"></script>
        <script src="vendor/datatables/jquery.dataTables.js"></script>
        <script src="vendor/datatables/dataTables.bootstrap4.js"></script>
        <script src="js/sb-admin.min.js"></script>
        <script src="js/sb-admin-datatables.min.js"></script>
        <script src="js/sb-admin-charts.min.js"></script>
        <script src="js/bootstrap4-toggle.js"></script>
        <script src="js/alert.js"></script>
        <script src="js/traer_clases.js?v=1.0.3" type="text/javascript"></script>
        <script src="js/enviar_datos.js?v=1.0.3"></script>
        <script src="js/jquery.preloaders.js"></script> 
        <script src="js/combo_buscar.js?v=1.0.3"></script>
        <script src="libreria_calendario/picker.js"></script>
        <script src="libreria_calendario/picker.date.js"></script>
        <script src="libreria_calendario/picker.time.js"></script>
        <script src="libreria_calendario/legacy.js"></script>
        <script src="libreria_calendario/main.js"></script>
        <script src="libreria_calendario/rainbow.js"></script>  
        <script src="js/SweetAlert.js"></script>
        <script src="js/sweetalert2.js"></script>
        <script src="js/swetalert_net.js"></script>
        <script src="js/aprobacion.js?v=1.0.4"></script>
        <script src="js/cancelacion.js?v=1.0.3"></script>
        <script src="js/insert_ot.js?v=1.0.3"></script>
 
</body>

</html>

