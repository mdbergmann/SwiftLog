SwiftLog is a logging frameword for the Swift language.

Using it is easy:

- Configure logging

This should be done once at initialisation of ther application:

```
// init the config factory
let c = ConfigurationFactory.sharedInstance.get()
// set the global log level threshold
c.logLevel = Level.Debug

```

- Configure a console appender

This should also be done at a initialization phase.


```
// add a console appender, it will write to STDOUT
let c = ConfigurationFactory.sharedInstance.get()
c.addAppender(ConsoleAppender())
```

- Create a logger

Do this for each instance you want to log from.

```
let l = Logger(name:"LoggerName")

```

- Log something

```
l.debug(msg:"Foo bar")
```

This will result in a log line as this:

```
09.02.16, 19:28:44 [DEBUG] LoggerName testCreateLogger() - Foo
```

By default this will log date, time, the log level, the name of the logger, the method it was issued in and, finally, the log message.

- Use the FileAppender for logging to file

```
let c = ConfigurationFactory.sharedInstance.get()
c.addAppender(FileAppender(fileUrl:NSURL(string:"file:///tmp/log.log")!))
```

The FileAppender will log to a file given as file URL.