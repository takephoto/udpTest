
import java.io.OutputStream;
import java.net.DatagramPacket;
import java.net.DatagramSocket;
import java.net.InetAddress;


public class Main {

    public static void main(String[] args) {
	// write your code here
        //SpringApplication.run(Main.class) ;

        try {
            DatagramSocket socket = new DatagramSocket(8888) ;
            byte buff[] = new byte[1024] ;
           // byte rBuff[] = new byte[1024] ;
            DatagramPacket packet = new DatagramPacket(buff,buff.length) ;
           // DatagramPacket sendPacket = new DatagramPacket(rBuff,rBuff.length) ;
            while (true) {
                socket.receive(packet);
                String reciveText = new String(buff,0,packet.getLength()) ;
                System.out.println(reciveText);
                String responText = "Hello" + reciveText ;
                byte rBuff[] = responText.getBytes() ;

                InetAddress address = packet.getAddress() ;
                int port = packet.getPort() ;
                DatagramPacket sendPacket = new DatagramPacket(rBuff,rBuff.length,address,port) ;
                socket.send(sendPacket);
            }
        }catch (Exception e){
            e.printStackTrace();
        }


    }
}
