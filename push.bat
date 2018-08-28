
@echo push github
@git pull origin master
@git add .
@git commit -m "code build dispense to service"
@git push -u origin master -f