# Raspberry PI GPS/GNSS with PPS


## Resources: 

	- Main tutorial:  [Revisiting Microsecond Accurate NTP for Raspberry Pi with GPS PPS in 2025 - Austin's Nerdy Things](https://austinsnerdythings.com/2025/02/14/revisiting-microsecond-accurate-ntp-for-raspberry-pi-with-gps-pps-in-2025/)
	- Repo:  [dkaulukukui/docker_gpsd_alpine](https://github.com/dkaulukukui/docker_gpsd_alpine)
	- GPSD references:  [GPSD Time Service HOWTO](https://gpsd.gitlab.io/gpsd/gpsd-time-service-howto.html)
	- PPS tools resources: https://github.com/redlab-i/pps-tools?tab=readme-ov-file
	- Chrony resource: https://chrony-project.org/
	

## Efforts so far: 

Followed the main tutorial above and was able to get everything working with both the Adafruit GPS featherwing and the Sparkfun Zed board <br>

Containerization efforts
- Alpine based container
- See repo - dkaulukukui/docker_gpsd_alpine
- So far I am able to run the container and verify PPS (step 4 from the main tutorial) however when I check GPS via gpsmon there is no PPS offset shown. 
- Current issues: 
	- When chrony is configured to use refclock PPS an error is kicked out saying that module is not compiled in 

   		> 2025-05-28T22:53:23Z Fatal error : refclock driver PPS is not compiled in
	
 	- When GPSD container is started the follow warnings are displayed: 
			
		> gpsd:WARN: KPPS:/dev/ttyAMA0 no HAVE_SYS_TIMEPPS_H, PPS accuracy will suffer
  		> 	
		> gpsd:WARN: KPPS:/dev/pps0 no HAVE_SYS_TIMEPPS_H, PPS accuracy will suffer
		>
  		> gpsd:WARN: PPS:/dev/pps0 die: no TIOMCIWAIT, nor RFC2783 CANWAIT
			

## Workflow to reproduce issue on raspi: 
- From ~/NTP/rpi-docker-gpsd
- Build container
	>  sudo docker build -t rpi-gpsd ~/NTP/rpi-docker-gpsd/
- Run container
 	> sudo docker run --rm -it --device=/dev/ttyAMA0 --device=/dev/pps0 -p 2948:2947 --name gpsd --privileged rpi-gpsd
- Launch another terminal and run
	> Sudo docker exec -it gpsd bash

- Check PPS
	> Sudo ppstest /dev/pps0
- Check gps
	> Cgps <br>
	> Gpsmon
- Try to launch chrony
	> /usr/sbin/chronyd -u chrony -d -x -L 3
 - ERROR response of 	
 	> 2025-05-28T22:53:23Z Fatal error : refclock driver PPS is not compiled in!
