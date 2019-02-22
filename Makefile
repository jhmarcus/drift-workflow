clean: 
	rm output.tar.gz

compress:
	tar -cvzf output.tar.gz output/

download:
	rm -f .ssh/known_hosts;scp -r jhmarcus@midway2.rcc.uchicago.edu:/project/jnovembre/jhmarcus/drift-workflow/output.tar.gz ./
