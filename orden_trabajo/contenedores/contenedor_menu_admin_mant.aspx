<%@ Page Language="C#" AutoEventWireup="true"  %>
 
  <%       if (Session["nombre_usuario"] == null)
    {
         Response.Redirect("login.aspx");
       
    }  %>
         <div class="col-xl-3 col-sm-6 mb-3" style="display:none" >
          <div class="card text-white bg-dark o-hidden h-100" onclick="traer_ot();">
            <div class="card-body">
              <div class="card-body-icon">
                <i class="fa fa-fw fa-calculator"></i>
              </div>
              <div class="mr-5">Pedido de Trabajo</div>
            </div>
              <a  class="card-footer text-white clearfix small z-1" href="#" onclick="traer_ot();">
              <span class="float-left">IR</span>
              <span class="float-right">
                <i class="fa fa-angle-right"></i>
              </span>
            </a>
          </div>
        </div>

  <div class="col-xl-3 col-sm-6 mb-3"  onclick="traer_informe_ot_mant('P44444401');">
          <div class="card text-white bg-danger o-hidden h-100" >
            <div class="card-body">
              <div class="card-body-icon">
                <i class="fa fa-fw fa-calendar-check-o"></i>
              </div>
              <div class="mr-5">PENDIENTES DE APROBACION MANTENIMIENTO</div>
            </div>
              <a   class="card-footer text-white clearfix small z-1" href="#"  ">
              <span class="float-left">IR</span>
              <span class="float-right">
                <i class="fa fa-angle-right"></i>
              </span>
            </a>
          </div>
        </div>


  <div class="col-xl-3 col-sm-6 mb-3"  onclick="traer_informe_ot_mant('P44444402');" id="div_logistica" style="display:none">
          <div class="card text-white bg-success o-hidden h-100" >
            <div class="card-body">
              <div class="card-body-icon">
                <i class="fa fa-fw fa-calendar-check-o"></i>
              </div>
              <div class="mr-5">PENDIENTES DE APROBACION LOGISTICA</div>
            </div>
              <a   class="card-footer text-white clearfix small z-1"  ">
              <span class="float-left">IR</span>
              <span class="float-right">
                <i class="fa fa-angle-right"></i>
              </span>
            </a>
          </div>
        </div>

<div class="col-xl-3 col-sm-6 mb-3"  id="div_resolucion" style="display:none">
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

 <div class="col-xl-3 col-sm-6 mb-3" >
          <div class="card text-white  bg-success o-hidden h-100" onclick="traer_contendor_informe_perfil3()">
            <div class="card-body">
              <div class="card-body-icon">
                <i class="fa fa-fw fa-user"></i>
              </div>
              <div class="mr-5">VER ESTADO DE PEDIDOS</div>
            </div>
              <a class="card-footer text-white clearfix small z-1" href="#" onclick="traer_contendor_informe_perfil3()">
              <span class="float-left">IR</span>
              <span class="float-right">
                <i class="fa fa-angle-right"></i>
              </span>
            </a>
          </div>
        </div>  

<div class="col-xl-3 col-sm-6 mb-3"  onclick="ir_historial_pendientes_perf3();">
          <div class="card text-white bg-danger o-hidden h-100" >
            <div class="card-body">
              <div class="card-body-icon">
                <i class="fa fa-fw fa-calendar-check-o"></i>
              </div>
              <div class="mr-5">HISTORIAL PENDIENTES</div>
            </div>
              <a   class="card-footer text-white clearfix small z-1" href="#" onclick="ir_historial_pendientes_perf3();">
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


