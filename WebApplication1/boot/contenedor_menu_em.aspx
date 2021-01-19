<%@ Page Language="C#" AutoEventWireup="true"  %>
 
  <%       if (Session["nombre_usuario"] == null)
    {
         Response.Redirect("login.aspx");
       
    }  %>
         <div class="col-xl-3 col-sm-6 mb-3" >
          <div class="card text-black  o-hidden h-100" onclick="traer_informe_resolucion();">
            <div class="card-body">
              <div class="card-body-icon">
                <i class="fa fa-fw fa-pencil"></i>
              </div>
              <div class="mr-5">PENDIENTE DE RESOLUCION</div>
            </div>
              <a  class="card-footer text-black clearfix small z-1" href="#" onclick="traer_informe_resolucion();">
              <span class="float-left">IR</span>
              <span class="float-right">
                <i class="fa fa-angle-right"></i> 
              </span>
            </a>
          </div>
        </div>

  <div class="col-xl-3 col-sm-6 mb-3"  onclick="traer_informe_asignacion();">
          <div class="card text-white bg-success o-hidden h-100" >
            <div class="card-body">
              <div class="card-body-icon">
                <i class="fa fa-fw fa-user"></i>
              </div>
              <div class="mr-5">PENDIENTES DE ASIGNACION DE OPERARIOS</div>
            </div>
              <a   class="card-footer text-white clearfix small z-1" href="#" onclick="traer_informe_asignacion();">
              <span class="float-left">IR</span>
              <span class="float-right">
                <i class="fa fa-angle-right"></i>
              </span>
            </a>
          </div>
        </div>

 <div class="col-xl-3 col-sm-6 mb-3" >
          <div class="card text-white  bg-success o-hidden h-100" onclick="traer_contendor_cambiar_pass_asp()">
            <div class="card-body">
              <div class="card-body-icon">
                <i class="fa fa-fw fa-user"></i>
              </div>
              <div class="mr-5">CAMBIAR CONTRASEÑA</div>
            </div>
              <a class="card-footer text-white clearfix small z-1" href="#" onclick="traer_contendor_cambiar_pass_asp()">
              <span class="float-left">IR</span>
              <span class="float-right">
                <i class="fa fa-angle-right"></i>
              </span>
            </a>
          </div>
        </div>    