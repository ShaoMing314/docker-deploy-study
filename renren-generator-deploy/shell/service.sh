#!/bin/bash
#程序名称
APP_NAME=/opt/project/docker-deploy-study/renren-generator-deploy/shell/renren-generator.jar


#日志文件路径及名称（目录按照各自配置）
LOG_FILE=/opt/project/docker-deploy-study/renren-generator-deploy/shell/renren-generator.log


# 项目启动的 jvm 参数
JVM_OPTS="-Dname=$AppName  -Duser.timezone=Asia/Shanghai -Xms512m -Xmx1024m -XX:MetaspaceSize=128m -XX:MaxMetaspaceSize=512m -XX:+HeapDumpOnOutOfMemoryError -XX:+PrintGCDateStamps  -XX:+PrintGCDetails -XX:NewRatio=1 -XX:SurvivorRatio=30 -XX:+UseParallelGC -XX:+UseParallelOldGC"



# 项目启动端口号
PORT=81

# 判断项目jar包试凑存在
if [ ! -f  $APP_NAME ];
then
    echo  "没有找到项目jar包"
    exit 1
fi

# 根据选择对项目进行相应的操作
if [ "$1" = "" ];
then
    echo -e "\033[0;31m 未输入操作名 \033[0m  \033[0;34m {start|stop|restart|status} \033[0m"
    exit 1
fi

# 开启项目
function start()
{
    PID=`ps -ef |grep java|grep $APP_NAME|grep -v grep|awk '{print $2}'`

	if [ x"$PID" != x"" ]; then
	    echo "$APP_NAME is running..."
	else
		nohup java $JVM_OPTS  -jar $APP_NAME --server.port=$PORT > $LOG_FILE 2>&1 &
		echo "Start $APP_NAME success..."
		# 查看项目启动日志
		tail -f $LOG_FILE
	fi
}

# 停止项目
function stop()
{
    echo "Stop $APP_NAME"

	PID=""
	query(){
		PID=`ps -ef |grep java|grep $APP_NAME|grep -v grep|awk '{print $2}'`
	}

	query
	if [ x"$PID" != x"" ]; then
		kill -9 $PID
		echo "$APP_NAME (pid:$PID) exiting..."
		while [ x"$PID" != x"" ]
		do
			sleep 1
			query
		done
		echo "$APP_NAME exited."
	else
		echo "$APP_NAME already stopped."
	fi
}

# 重启项目
function restart()
{
    stop
    sleep 2
    start
}

# 查看项目运行状态,看是否运行
function status()
{
    PID=`ps -ef |grep java|grep $APP_NAME|grep -v grep|wc -l`
    if [ $PID != 0 ];then
        echo "$APP_NAME is running..."
    else
        echo "$APP_NAME is not running..."
    fi
}


case $1 in
    start)
    start;;
    stop)
    stop;;
    restart)
    restart;;
    status)
    status;;
    *)

esac





