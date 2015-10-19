import socket
s=socket.socket(socket.AF_INET,socket.SOCK_DGRAM)
#s.setsockopt(SOL_SOCKET, SO_REUSEADDR, 1)
s.bind(('0.0.0.0',30001))
waiting_list=set()

while True:
    (data,addres_client)=s.recvfrom(1024)
    print data
    waiting_list.add(addres_client)
    if data=='please connect us!!!':
        print 'I will connect you all my sons'
        if len(waiting_list)<2:
            print 'not enough clients to continue wait for another to connect'
            continue
        for addr in waiting_list:
            if addr!=addres_client:
                s.sendto('Yes do you want to connect with your friend?'+'\0',addr)
                print 'I sent: Yes do you want to connect with your friend?'
    
        s.settimeout(0.5)
        data2=None
        print 'trying to recieve data'
        try:
            (data2,addr)=s.recvfrom(1024)
        except:
            pass
        s.settimeout(None)
        if data2=='yes i am sure':
            s.sendto('You are the host!!!'+'\0',addr)
            #s.sendto('You are not the host!!!'+'\0',addr)
            print 'sending ip and port to one another'
            s.sendto('Get ready for IP.'+'\0',addr)
            s.sendto('Get ready for IP.'+'\0',addres_client)
            s.sendto(str(addres_client[0])+'\0',addr)#ip
            print 'sent: '+str(addres_client[0])+' to: ' +str(addr)
            s.sendto(str(addres_client[1])+'\0',addr)#port
            print 'sent: '+str(addres_client[1])+' to: ' +str(addr)
            s.sendto(str(addr[0])+'\0',addres_client)
            print 'sent: '+str(addr[0])+ ' to: ' +str(addres_client)
            s.sendto(str(addr[1])+'\0',addres_client)
            print ('I sent: '+str(addr[1])+' to: '+str(addres_client))
            waiting_list.discard(addres_client)
            waiting_list.discard(addr)