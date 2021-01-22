<%@ Page Language="C#" AutoEventWireup="true"  %>

<!DOCTYPE html>

 <html lang="en">
 
<head>
    <meta content="width=device-width, initial-scale=1" name="viewport"/>
     <% @Import Namespace="WebApplication1"%>
     <%
               if (Session["nombre_usuario"] == null)
    {
         Response.Redirect("login.aspx");
       
    } 
     String nombre_usuario= Session["nombre_usuario"].ToString();
     String perfil = Session["perfil"].ToString();
     String id_usuario = Session["id_usuario"].ToString();
    %>
   
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

 
        <nav class="navbar navbar-expand-lg navbar-dark bg-dark fixed-top" id="mainNav">
     
        <a class="navbar-brand" href="#" onclick="ir_menu('<%=perfil %>');"><h6>    <i class="fa fa-fw fa-user"></i>  USUARIO: <%=nombre_usuario%>  </h6></a>
        <input type="text" class="" name="linea" style="display:none"value="" readonly="readonly" >
        <button class="navbar-toggler navbar-toggler-right" type="button" data-toggle="collapse" data-target="#navbarResponsive" aria-controls="navbarResponsive" aria-expanded="false" aria-label="Toggle navigation">
        <span class="navbar-toggler-icon"></span>
        </button>
        <div class="collapse navbar-collapse" id="navbarResponsive">
     
     
        <ul class="navbar-nav ml-auto">
        <li class="nav-item">
            <a class="nav-link" data-toggle="modal" data-target="#exampleModal">
            <i class="fa fa-fw fa-sign-out"></i>Cerrar sesion</a>
        </li>
        </ul>
        </div>
  </nav>
  <br><br><br> 
  
    <div class="container-fluid">
       
       
     <div   id="contenido_principal" class="row">
            </div>

          <div   id="contenido" >
        
       </div>
    
    <div class="modal fade" id="exampleModal" tabindex="-1" role="dialog" aria-labelledby="exampleModalLabel" aria-hidden="true">
      <div class="modal-dialog" role="document">
        <div class="modal-content">
          <div class="modal-header">
            <h5 class="modal-title" id="exampleModalLabel">Mensaje?</h5>
            <button class="close" type="button" data-dismiss="modal" aria-label="Close">
              <span aria-hidden="true">×</span>
            </button>
          </div>
          <div class="modal-body">Desea cerrar sesión?</div>
          <div class="modal-footer">
            <button class="btn btn-secondary" type="button" data-dismiss="modal">Cancelar</button>
            <a class="btn btn-primary" href="cerrar_sesion.aspx">Cerrar</a>
          </div>
        </div>
      </div>
    </div>  </div>   
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
 
        <script src="js/traer_clases.js" type="text/javascript"></script>
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
        <script src="js/controles.js?v=1.0.4"></script>
        <script src="js/cancelacion.js?v=1.0.3"></script>
 
</body>

</html>

