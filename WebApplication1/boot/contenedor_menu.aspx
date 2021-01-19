<%@ Page Language="C#" AutoEventWireup="true" %>

 <%       if (Session["nombre_usuario"] == null)
    {
         Response.Redirect("login.aspx");
       
    }  %>
         <div class="col-xl-3 col-sm-6 mb-3" >
          <div class="card text-white bg-dark o-hidden h-100" onclick="traer_ot();cargar();">
            <div class="card-body">
              <div class="card-body-icon">
                <i class="fa fa-fw fa-calculator"></i>
              </div>
              <div class="mr-5">Pedido de Trabajo</div>
            </div>
              <a  class="card-footer text-white clearfix small z-1" href="#" onclick="traer_ot();cargar();">
              <span class="float-left">IR</span>
              <span class="float-right">
                <i class="fa fa-angle-right"></i>
              </span>
            </a>
          </div>
        </div>

  <div class="col-xl-3 col-sm-6 mb-3"  onclick="traer_informe_ot();">
          <div class="card text-white bg-danger o-hidden h-100" >
            <div class="card-body">
              <div class="card-body-icon">
                <i class="fa fa-fw fa-calendar-check-o"></i>
              </div>
              <div class="mr-5">PENDIENTES</div>
            </div>
              <a   class="card-footer text-white clearfix small z-1" href="#" onclick="traer_informe_ot();">
              <span class="float-left">IR</span>
              <span class="float-right">
                <i class="fa fa-angle-right"></i>
              </span>
            </a>
          </div>
        </div>



  <div class="col-xl-3 col-sm-6 mb-3"  onclick="traer_informe_verificacion();">
          <div class="card text-white bg-warning o-hidden h-100" >
            <div class="card-body">
              <div class="card-body-icon">
                <i class="fa fa-fw fa-calendar-check-o"></i>
              </div>
              <div class="mr-5">PENDIENTES DE VERIFICACION</div>
            </div>
              <a   class="card-footer text-white clearfix small z-1" href="#" onclick="traer_informe_verificacion();">
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


 <div class="col-xl-3 col-sm-6 mb-3" >
          <div class="card text-white  bg-success o-hidden h-100" onclick="traer_contendor_informe_perfil1()">
            <div class="card-body">
              <div class="card-body-icon">
                <i class="fa fa-fw fa-user"></i>
              </div>
              <div class="mr-5">VER ESTADO DE PEDIDOS</div>
            </div>
              <a class="card-footer text-white clearfix small z-1" href="#" onclick="traer_contendor_informe_perfil1()">
              <span class="float-left">IR</span>
              <span class="float-right">
                <i class="fa fa-angle-right"></i>
              </span>
            </a>
          </div>
        </div>  