package kr.co.lscns.SD.WGBC;

public class SD1890_WGBC_SOProxy implements kr.co.lscns.SD.WGBC.SD1890_WGBC_SO {
  private String _endpoint = null;
  private kr.co.lscns.SD.WGBC.SD1890_WGBC_SO sD1890_WGBC_SO = null;
  
  public SD1890_WGBC_SOProxy() {
    _initSD1890_WGBC_SOProxy();
  }
  
  public SD1890_WGBC_SOProxy(String endpoint) {
    _endpoint = endpoint;
    _initSD1890_WGBC_SOProxy();
  }
  
  private void _initSD1890_WGBC_SOProxy() {
    try {
      sD1890_WGBC_SO = (new kr.co.lscns.SD.WGBC.SD1890_WGBC_SOServiceLocator()).getHTTP_Port();
      if (sD1890_WGBC_SO != null) {
        if (_endpoint != null)
          ((javax.xml.rpc.Stub)sD1890_WGBC_SO)._setProperty("javax.xml.rpc.service.endpoint.address", _endpoint);
        else
          _endpoint = (String)((javax.xml.rpc.Stub)sD1890_WGBC_SO)._getProperty("javax.xml.rpc.service.endpoint.address");
      }
      
    }
    catch (javax.xml.rpc.ServiceException serviceException) {}
  }
  
  public String getEndpoint() {
    return _endpoint;
  }
  
  public void setEndpoint(String endpoint) {
    _endpoint = endpoint;
    if (sD1890_WGBC_SO != null)
      ((javax.xml.rpc.Stub)sD1890_WGBC_SO)._setProperty("javax.xml.rpc.service.endpoint.address", _endpoint);
    
  }
  
  public kr.co.lscns.SD.WGBC.SD1890_WGBC_SO getSD1890_WGBC_SO() {
    if (sD1890_WGBC_SO == null)
      _initSD1890_WGBC_SOProxy();
    return sD1890_WGBC_SO;
  }
  
  public kr.co.lscns.SD.WGBC.DT_SD1890_WGBC_response SD1890_WGBC_SO(kr.co.lscns.SD.WGBC.DT_SD1890_WGBC MT_SD1890_WGBC) throws java.rmi.RemoteException{
    if (sD1890_WGBC_SO == null)
      _initSD1890_WGBC_SOProxy();
    return sD1890_WGBC_SO.SD1890_WGBC_SO(MT_SD1890_WGBC);
  }
  
  
}