<%@ Page Language="C#" AutoEventWireup="true"  %>
<% @Import Namespace="SAPbobsCOM" %>
<% @Import Namespace="System" %>
<% @Import Namespace="WebApplication1" %>
<% @Import Namespace="System.Data.SqlClient" %>
 <% @Import Namespace="System.Net.Mail" %> 
 <% @Import Namespace="Newtonsoft.Json.Linq" %> 
 <% @Import Namespace="Newtonsoft.Json" %> 
<%

    Company empresa = new Company();
    ServiceCalls OT;
    Contacts Actividad;
    string clgcode = "";
    String nro_ot = "";
    String con_gmaehara = Global.gm_conn;
    SqlConnection conex_gmehara = new SqlConnection(con_gmaehara);
    String CardCode = Request.Params["condicion_ot"];
    String id_categoria = "";
    String maquina = "";
    String tipo_problema = "";

    String descripcion = Request.Params["description"];
    String fecha_necesaria = Request.Params["fecha_log"];
    String origen = Request.Params["cbox_origen"];
    String problema = Request.Params["txt_problema"];
    String id_usuario = Session["id_usuario"].ToString();
    String area = Session["area"].ToString();
    String mail_get = Session["correo"].ToString();
    String nombre_usuario = Session["nombre_usuario_gm"].ToString();

    String mail = "";
    String perfil = Session["perfil"].ToString();
    String mensaje_pendiente = "";
    int estado_orden = 0;
    String tipo_mensaje = "";
    String mensaje_resultado = "";

    if (CardCode.Equals("P44444401"))//CARD CODE P44444401= MANTENIMIENTO, SE RECUPERA EL ID_CATEGORIA, MAQUINA Y EL TIPO DE PROBLEMA, SON DATOS OBLIGATORIOS PARA ESTE CASO.
    {
        id_categoria    = Request.Params["id_categoria"];
        maquina         = Request.Params["cbox_maquina"];
        tipo_problema   = Request.Params["cbox_tipo_problem"];

        if (area.Equals("TALLER")||area.Equals("LOG")||perfil.Equals("2"))//NOTA, TALLER Y LOG NO CUENTAN CON PERFILES DOS, ENTONCES DIRECTAMENTE PASA A PENDIENTE DE MANTENIMIENTO.
        {
            mensaje_pendiente = "PENDIENTE APROBACION MANTENIMIENTO";
            estado_orden = 2;
            mail = mail_get;
        }

        else if (perfil.Equals("1"))//NOTA, TODOS LOS PERFILES 1 VAN A PENDIENTE DE APROBACION MANTENIMIENTO POR JEFE DE AREA EN EL CASO DEL CARD CODE 401.
        {
            mensaje_pendiente = "PENDIENTE DE APROBACION";
            estado_orden = 1;
            mail = mail_get;
        }
    }
    else if(CardCode.Equals("P44444402"))//CARD CODE P44444402= LOGISTICA
    {

        if (area.Equals("LOG"))
        {
            mensaje_pendiente = "PENDIENTE APROBACION JEFE LOGISTICA";// NOTA, AREA LOG SIEMPRE PASA AL ESTADO 7, PARA QUE LO APRUEBE EL JEFE DE LOGISTICA.
            estado_orden = 7;
            mail = mail_get;// EN ESTE CASO DEBERIA DE LLEGARLE EL CORREO AL JEFE DE LOGISTICA, EN ESTE CASO LIZ LEON.

        }
        else
        {

            if (perfil.Equals("1"))
            {
            mensaje_pendiente = "PENDIENTE APROBACION LOGISTICA"; // NOTA, TODOS LOS PERFILES 1 VAN  A PENDIENTE DE APROBACION LOGISTICA, EN EL CASO DEL CARD CODE 402.
            estado_orden = 1;
            mail = mail_get; // 

            }
            else if (perfil.Equals("2"))
            {
            mensaje_pendiente = "PENDIENTE APROBACION JEFE LOGISTICA";// NOTA, TODOS LOS PERFILES 2, AL CREAR EL PEDIDO, VAN A PENDIENTE JEFE LOGISTICA, EN EL CASO DEL CARD CODE 402.
            estado_orden = 7;
            mail = mail_get;// EN ESTE CASO DEBERIA DE LLEGARLE EL CORREO AL JEFE DE LOGISTICA, EN ESTE CASO LIZ LEON.

            }
        }
       
    }

    empresa.Server = Global.server;
    empresa.CompanyDB = Global.companydb;
    switch (Global.sap_dbservertype)
    {
        case "2014":
            empresa.DbServerType = BoDataServerTypes.dst_MSSQL2014;
            break;
    };
    empresa.DbUserName = Global.DBuserName;
    empresa.DbPassword = Global.DBpassword;
    empresa.UserName = Session["usuario"].ToString();
    empresa.Password = Session["pass"].ToString();

    try
    {
        if (empresa.Connected == false)
        {
            if (empresa.Connect() != 0)
            {

                tipo_mensaje = "1";
                mensaje_resultado = (empresa.GetLastErrorDescription() + "; Código de error :" + empresa.GetLastErrorCode().ToString());
            }
            else
            {
                empresa.StartTransaction();

                Actividad = (Contacts)empresa.GetBusinessObject(BoObjectTypes.oContacts);
                Actividad.CardCode = CardCode;
                Actividad.ActivityType = -1;
                Actividad.Activity = BoActivities.cn_Other;
                Actividad.Details = "CREACION DEL PEDIDO DE TRABAJO";
                Actividad.Notes = "CREACION DEL PEDIDO DE TRABAJO";
                Actividad.EndDuedate = DateTime.Now.Date;
                Actividad.EndTime = DateTime.Parse(DateTime.Now.ToString("HH:mm"));
                Actividad.Closed = BoYesNoEnum.tYES;

                if (Actividad.Add() != 0)
                {
                    tipo_mensaje = "1";
                    mensaje_resultado = (empresa.GetLastErrorDescription() + "; Código de error :" + empresa.GetLastErrorCode().ToString());

                    empresa.EndTransaction(BoWfTransOpt.wf_RollBack);
                    return;
                }
                else
                {
                    clgcode = empresa.GetNewObjectKey();

                    OT = (ServiceCalls)empresa.GetBusinessObject(BoObjectTypes.oServiceCalls);
                    OT.Activities.ActivityCode = int.Parse(clgcode);
                    OT.ServiceBPType = ServiceTypeEnum.srvcPurchasing;
                    OT.CustomerCode = CardCode;
                    OT.Subject = problema;
                    OT.Description = descripcion;
                    OT.Origin = int.Parse(origen.Trim());
                    OT.Activities.UserFields.Fields.Item("U_Id_Usuario").Value = int.Parse(id_usuario);
                    OT.Activities.UserFields.Fields.Item("U_usuario").Value = nombre_usuario;
                    if (CardCode.Equals("P44444401")) {
                        OT.ProblemType = int.Parse(tipo_problema);
                        OT.UserFields.Fields.Item("U_recurso").Value = maquina;
                        OT.UserFields.Fields.Item("U_sub_categoria").Value = id_categoria;
                    }
                    else
                    {
                        OT.UserFields.Fields.Item("U_fechanec").Value = DateTime.Parse(fecha_necesaria);
                    }

                    OT.Status = estado_orden;
                    if (OT.Add() != 0)
                    {
                        tipo_mensaje = "1";
                        mensaje_resultado = (empresa.GetLastErrorDescription() + "; Código de error :" + empresa.GetLastErrorCode().ToString());

                        empresa.EndTransaction(BoWfTransOpt.wf_RollBack);
                        return;
                    }
                    nro_ot = empresa.GetNewObjectKey();
                    OT = (ServiceCalls)empresa.GetBusinessObject(BoObjectTypes.oServiceCalls);
                    OT.GetByKey(int.Parse(nro_ot));
                    Actividad = (Contacts)empresa.GetBusinessObject(BoObjectTypes.oContacts);
                    Actividad.CardCode = CardCode;
                    Actividad.ActivityType = -1;
                    Actividad.Activity = BoActivities.cn_Other;
                    Actividad.Details =mensaje_pendiente;
                    Actividad.Notes = "";
                    Actividad.EndDuedate = DateTime.Now.Date;
                    Actividad.EndTime = DateTime.Parse(DateTime.Now.ToString("HH:mm"));

                    if (Actividad.Add() != 0)
                    {
                        tipo_mensaje = "1";
                        mensaje_resultado = (empresa.GetLastErrorDescription() + "; Código de error :" + empresa.GetLastErrorCode().ToString());
                        empresa.EndTransaction(BoWfTransOpt.wf_RollBack);
                        return;
                    }

                    else
                    {
                        clgcode = empresa.GetNewObjectKey();

                        OT.Activities.Add();
                        OT.Activities.ActivityCode = int.Parse(clgcode);
                        OT.Activities.UserFields.Fields.Item("U_Id_Usuario").Value = int.Parse(id_usuario);
                        OT.Activities.UserFields.Fields.Item("U_usuario").Value = nombre_usuario;

                        if (OT.Update() != 0)

                        {
                            tipo_mensaje = "1";
                            mensaje_resultado = (empresa.GetLastErrorDescription() + "; Código de error :" + empresa.GetLastErrorCode().ToString());


                        };
                    }

                };
            };
            empresa.EndTransaction(BoWfTransOpt.wf_Commit);

            tipo_mensaje = "0";
            mensaje_resultado = "REGISTRADO CON EXITO";
            SmtpClient correo = new SmtpClient();
            correo.Port = 587;
            correo.Host = "smtp.gmail.com";
            correo.EnableSsl = true;
            correo.DeliveryMethod = SmtpDeliveryMethod.Network;
            correo.UseDefaultCredentials = false;
            correo.Credentials = new System.Net.NetworkCredential("reportes.vmiis@gmail.com", "gm$123456789");
            String mail_1 = "";
            String mail_2 = "";

            //MailMessage mm = new MailMessage("reportes.vmiis@gmail.com", "felix.gaona@yemita.com.py", "Error Interface CAST", msj);
            MailMessage mm = new MailMessage();
            mm.From = new MailAddress("reportes.vmiis@gmail.com");

            if (mail.Contains("-"))
            {
                String[] mail_arr = mail.Split('-');

                mail_1=mail_arr[0];
                mail_2=mail_arr[1];
                mm.To.Add(mail_1);
                mm.To.Add(mail_2);
            }
            else
            {
                mm.To.Add(mail);
            }
            mm.Subject = "PEDIDO DE TRABAJO";
            mm.Body = "SOLICITUD NRO: "+clgcode+" \n\n SOLICITADO POR: "+nombre_usuario+" \n\n DESCRIPCION: "+descripcion+"\n\n DETALLE: "+problema;
            //    correo.Send(mm);
        };
    }
    catch (Exception ex)
    {
        if (empresa.InTransaction)
        {
            empresa.EndTransaction(BoWfTransOpt.wf_RollBack);

        };
        tipo_mensaje = "1";
        mensaje_resultado = ex.ToString();
    }
    finally
    {

        if (empresa.Connected)
        {
            empresa.Disconnect();

        };

        JObject ob = new JObject();
        ob = new JObject();
        ob.Add("tipo_mensaje", tipo_mensaje);
        ob.Add("mensaje_resultado", mensaje_resultado);
        Response.Write(ob);
        Response.ContentType = "application/json; charset=utf-8";
        Response.End();

    }; %>
   