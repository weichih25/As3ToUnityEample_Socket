using UnityEngine;
using System.Collections;
using System;
using System.Net;
using System.Net.Sockets;
using System.Text;
using System.Threading;


public class StageMachine : MonoBehaviour {

	private int recv;
	private byte[] data; 
	private TcpListener newsock ;
	private TcpClient client ;
	private NetworkStream ns;
	private string debugString;
	private Thread oThread;
	
	void Start () {
		Screen.SetResolution (400, 400, false);
		Init ();
	}

	void Update () {

		if (!oThread.IsAlive) {
			oThread = new Thread(new ThreadStart(this.SocketProcess));
			oThread.Start ();
		}

	}

	void OnGUI(){
		GUI.Box (new Rect (0, 0, Screen.width, Screen.height), debugString);
	}

	void Init(){
		data = new byte[1024];
		newsock = new TcpListener(9050);
		newsock.Start();
		debugString = "Waiting for a client...\n"+ debugString;
		
		oThread = new Thread(new ThreadStart(this.SocketProcess));
		oThread.Start ();	
	}
	
	void SocketProcess(){
		if( newsock != null){
			if(newsock.Pending())
			{
				client = newsock.AcceptTcpClient();
				ns = client.GetStream();
				debugString = "Connect to client\n"+ debugString;
			}
			if (client != null) {
				byte[] buff = new byte[1];
				if( client.Client.Receive( buff, SocketFlags.Peek ) == 0 )
				{	
					ns.Close();
					client.Close();
					newsock.Stop();
					newsock = null;
					ns = null;
					client = null;
					debugString = "Disconnect to cilent\n" + debugString; 
		
					Init();
					
				}else{
					data = new byte[1024];
					recv = ns.Read(data, 0, data.Length);
					debugString = "Client say :" + 
						Encoding.ASCII.GetString (data, 0, recv) + "\n"+ debugString;
				}
				
				
			} 
		}
		
	}
}
