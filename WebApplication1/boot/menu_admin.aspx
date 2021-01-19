<%@ Page Language="C#" AutoEventWireup="true"  %>

 <% @Import Namespace="Libreria"%>
 <%
           if (Session["nombre_usuario"] == null)
    {
         Response.Redirect("login.aspx");
       
    } 
     String nombre_usuario = Session["nombre_usuario_gm"].ToString();
         
         


     %>
 
        <nav class="navbar navbar-expand-lg navbar-dark bg-dark fixed-top" id="mainNav">
     
        <a class="navbar-brand" href="#" onclick="traer_menu_admin();"><h6>    <i class="fa fa-fw fa-user"></i>  USUARIO: <%=nombre_usuario %>  </h6></a>
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
       
      
          
 