package kr.co.lscns.SD.WPCS;

public class SD0980_WPCS_SOProxy implements kr.co.lscns.SD.WPCS.SD0980_WPCS_SO {
  private String _endpoint = null;
  private kr.co.lscns.SD.WPCS.SD0980_WPCS_SO sD0980_WPCS_SO = null;
  
  public SD0980_WPCS_SOProxy() {
    _initSD0980_WPCS_SOProxy();
  }
  
  public SD0980_WPCS_SOProxy(String endpoint) {
    _endpoint = endpoint;
    _initSD0980_WPCS_SOProxy();
  }
  
  private void _initSD0980_WPCS_SOProxy() {
    try {
      sD0980_WPCS_SO = (new kr.co.lscns.SD.WPCS.SD0980_WPCS_SOServiceLocator()).getHTTP_Port();
      if (sD0980_WPCS_SO != null) {
        if (_endpoint != null)
          ((javax.xml.rpc.Stub)sD0980_WPCS_SO)._setProperty("javax.xml.rpc.service.endpoint.address", _endpoint);
        else
          _endpoint = (String)((javax.xml.rpc.Stub)sD0980_WPCS_SO)._getProperty("javax.xml.rpc.service.endpoint.address");
      }
      
    }
    catch (javax.xml.rpc.ServiceException serviceException) {}
  }
  
  public String getEndpoint() {
    return _endpoint;
  }
  
  public void setEndpoint(String endpoint) {
    _endpoint = endpoint;
    if (sD0980_WPCS_SO != null)
      ((javax.xml.rpc.Stub)sD0980_WPCS_SO)._setProperty("javax.xml.rpc.service.endpoint.address", _endpoint);
    
  }
  
  public kr.co.lscns.SD.WPCS.SD0980_WPCS_SO getSD0980_WPCS_SO() {
    if (sD0980_WPCS_SO == null)
      _initSD0980_WPCS_SOProxy();
    return sD0980_WPCS_SO;
  }
  
  public kr.co.lscns.SD.WPCS.DT_SD0980_WPCS_responseGT_ORDER_INFO[] SD0980_WPCS_SO(kr.co.lscns.SD.WPCS.DT_SD0980_WPCS MT_SD0980_WPCS) throws java.rmi.RemoteException{
    if (sD0980_WPCS_SO == null)
      _initSD0980_WPCS_SOProxy();
    return sD0980_WPCS_SO.SD0980_WPCS_SO(MT_SD0980_WPCS);
  }
  
  
}