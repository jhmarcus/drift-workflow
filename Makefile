clean: 
	rm output.tar.gz

compress:
	tar -cvzf output.tar.gz output/;tar -cvzf data.tar.gz data/

download:
	rm -f ~/.ssh/known_hosts;scp -r jhmarcus@midway2.rcc.uchicago.edu:/project/jnovembre/jhmarcus/drift-workflow/*.tar.gz ./
