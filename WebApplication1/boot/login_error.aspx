<!DOCTYPE html>


<html xmlns="http://www.w3.org/1999/xhtml">
<head runat="server">
<meta http-equiv="Content-Type" content="text/html; charset=utf-8"/>
    <title>Acceso al Sistema</title>
      <!-- Bootstrap core CSS-->
  <link href="vendor/bootstrap/css/bootstrap.min.css" rel="stylesheet">
  <!-- Custom fonts for this template-->
  <link href="vendor/font-awesome/css/font-awesome.min.css" rel="stylesheet" type="text/css">
  <!-- Custom styles for this template-->
  <link href="css/sb-admin.css" rel="stylesheet">
    <link href="css/sweetalert.css" rel="stylesheet" />
</head>
    
  
      
<body  onload=" no_volver_atras();" class="bg-dark">
  <div class="container ">
    <div class="card card-login mx-auto mt-5 ">
      <div class="card-header bg-danger ">INICIO DE SESIÓN</div>
      <div class="card-body">
          <form action="logincontrol.aspx" method="post" autocomplete="off">
            <div class="form-group">
            <label for="exampleInputUser">Usuario</label>
            <input class="form-control" id="txt_usuario" name="txt_usuario" type="text"  placeholder="Ingrese su usuario" autocomplete="off"  required/>
          </div>
          <div class="form-group">
            <label for="exampleInputPassword1">Contraseña</label>
            <input class="form-control" id="txt_pass" name="txt_pass" type="password" placeholder="Contraseña" autocomplete="off" required />
          </div>
          <div class="form-group">
            
          </div>
                           

              <button class="btn btn-danger alert-light btn-block"  type="submit" onclick="validar();"><b>Ingresar</b> </button>
        
       
<div class="alert alert-danger" role="alert" id="alerta" >
                <span class="glyphicon glyphicon-exclamation-sign"></span>
           USUARIO O CONTRASEÑA INCORRECTA
            </div>        </form>
       
      </div>
    </div>
      
      
      
      
      
  </div>
 
      
       <script>
           function validar() {

               var usuario = $("#txt_usuario").val();
               var pass = $("#txt_pass").val();

               if (usuario == "" || pass== "") {

                   swal({
                        title: "ERROR, CARGAR DATOS",
                        confirmButtonText: "CERRAR"
                           });
               }
                   else {

                   cargar_loader();
                   }
               }


           function cargar_loader() {
                     
                    $.preloader.start({
                    modal: true,
                    src : 'sprites2.png'
                });
  }

        </script> 
  <script src="vendor/jquery/jquery.min.js"></script>
  <script src="vendor/bootstrap/js/bootstrap.bundle.min.js"></script>
   
  <script src="vendor/jquery-easing/jquery.easing.min.js"></script>
  <script src="js/traer_clases.js"></script>
        <script src="js/alerta.js"></script>
    <script src="js/jquery.preloaders.js"></script>
</body>
</html>

