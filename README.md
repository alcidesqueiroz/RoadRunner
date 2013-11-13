RoadRunner
=====

What is?
--------

RoadRunner is a simple, but powerful, live reload tool totally written in Ruby. Though RoadRunner was made in Ruby, it is language-agnostic, in simple words: you can use RoadRunner with ANY language or platform (or operating system) in your back-end. You just need ruby installed.


Usage
--------------------
1) Run:
```ruby
sudo gem install roadrunner
``` 

2) Create a roadrunner.yml file in the root folder of your project by running the command `roadrunner setup`.

Your file structure will look like this:
```yaml
config:
  polling_interval: 0.1
  change_check_strategy: modification_time #You also can use 'checksum'
  live_reload_port: 9876
  web_server_port: 9875
  files: [
           ["/relative/path/to/some/css-file.css", "/relative/path/in/your/web-server.css"],
           "/equivalent/path.css"
         ]

```
If the relative path for a file to be monitored in your project folder structure is equal to its URL in web server, you just have to add this path (relative to the root folder) to the "files" collection. 

```yaml
  files: [
           "/same/path.css",
           ...
         ]
```

But if the paths are different, you can map it easily:
```yaml
  files: [
           ["/relative/path/to/some/css-file.css", "/relative/path/in/your/web-server.css"],
           ...
         ]
```
3) RoadRunner also starts a tiny web server to serve the roadrunner.js script file. So, add a reference to this file in your application layout/template/master page.
```javascript
<script src="http://localhost:9875/roadrunner.js"></script>
```
4) Open a terminal, "cd" to your project root folder (where roadrunner.yml is located) and run: 
```
roadrunner
```
5) Open your application in your browser

License
-------
This code is free to use under the terms of the MIT license
