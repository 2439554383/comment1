import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'package:comment1/view_model/chat_viewmodel.dart';
import 'package:oktoast/oktoast.dart';
import 'package:open_file/open_file.dart';
import 'package:path_provider/path_provider.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart'as http;
import 'package:path_provider/path_provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
class http_api{
  general_api(String url,String text,List selecttext_list,String count,StreamController streamcontroller) async{
    print("selecttext_list:$selecttext_list");
    final request = await http.Request(
      "POST",
      Uri.parse(url),
      )
      ..body = json.encode({
        "url":text,
        "selecttext_list":selecttext_list,
        "count":count
      });
    final response = await request.send();
    if(response.statusCode == 200){
      print("请求成功");
      response.stream
          .transform(utf8.decoder)
          .listen((chunk) {
        if(!streamcontroller.isClosed){
          print("接收到片段：$chunk");
          streamcontroller.add(chunk);
        }
      }).onDone((){
        streamcontroller.close();
        print("传输结束，数据流关闭");
        print(streamcontroller.isClosed);
      });

    }
    else{
      streamcontroller.addError("error");
      Future.delayed(Duration(seconds: 1),(){
        streamcontroller.close();
        print("传输结束，数据流关闭");
        print(streamcontroller.isClosed);
      });
      print('请求失败');

    }
  }
  postimage_api(String url,String text,String image_path,String type,StreamController streamcontroller) async{
    final request = await http.MultipartRequest(
        "POST",
        Uri.parse(url),
        )
        ..fields['text'] = text
        ..fields['type'] = type
        ..files.add(await http.MultipartFile.fromPath('file',image_path));
    final response = await request.send();
    if(response.statusCode == 200){
      print("请求成功");
      response.stream
          .transform(utf8.decoder)
          .listen((chunk) {
        if(!streamcontroller.isClosed){
          print("接收到片段：$chunk");
          streamcontroller.add(chunk);
        }
      }).onDone((){
        streamcontroller.close();
        print("传输结束，数据流关闭");
        print(streamcontroller.isClosed);
      });
    }
    else{
      print('请求失败');
    }
  }
  post_text(String url,String text,String type,StreamController streamcontroller) async{
    final request = await http.Request(
      "POST",
      Uri.parse(url),
      );
    request.body = json.encode({
      'type':type,
      'text':text
    });
    final response = await request.send();
    if(response.statusCode == 200){
      print("请求成功");
      response.stream
          .transform(utf8.decoder)
          .listen((chunk) {
            if(!streamcontroller.isClosed){
              print("接收到片段：$chunk");
              streamcontroller.add(chunk);
            }
      }).onDone((){
        streamcontroller.close();
        print("传输结束，数据流关闭");
        print(streamcontroller.isClosed);
      });
    }
    else{
      print('请求失败');
    }
  }
  all_api(String url,String code) async{
    final response = await http.post(
        Uri.parse(url),
        headers:{'Content-Type':'application/json'},
        body: json.encode({
          "code":code
        })
    );
    if(response.statusCode == 200){
      final data = json.decode(response.body);
      print("data:$data");
      return data;
    }
    else{
      print('请求失败');
    }
  }
  post_content(String url,String content,String code) async{
    final response = await http.post(
        Uri.parse(url),
        headers:{'Content-Type':'application/json'},
        body: json.encode({
          "content":content,
          "code":code
        })
    );
    if(response.statusCode == 200){
      if(content!=""){
        showToast("添加成功",backgroundColor: Colors.black54,position: ToastPosition.bottom,radius: 40,textStyle: TextStyle(color: Colors.white));
      }
      final data = json.decode(response.body);
      print("data:$data");
      return json.decode(response.body)['data'];
    }
    else{
      print('请求失败');
    }
  }
  get_list(String url) async{
    final response = await http.get(
      Uri.parse(url),
      headers:{'Content-Type':'application/json'},
    );
    if(response.statusCode == 200){
      print("请求成功");
      print(json.decode(response.body)['data']);
      return json.decode(response.body)['data'];
    }
    else{
      print('请求失败');
    }
  }
  post_aiface(String url,String old_image,String face_image) async{
    final request = await http.MultipartRequest(
      "POST",
      Uri.parse(url),
    )..files.add(await http.MultipartFile.fromPath("old_image",old_image))
    ..files.add(await http.MultipartFile.fromPath("face_image",face_image))
    ;
    final response = await request.send();
    if (response.statusCode == 200) {
      // 读取响应体字符串
      final respStr = await response.stream.bytesToString();
      // 解析 JSON
      final data = json.decode(respStr);
      print('请求成功，返回数据: $data');
      // 返回 data 里的 base64 或其他
      return data['data'];
    } else {
      print('请求失败，状态码：${response.statusCode}');
    }
  }
  post_code(String url,String code) async{
    final response = await http.post(
      Uri.parse(url),
      headers:{'Content-Type':'application/json'},
      body: json.encode({
        "code":code
      })
    );
    if(response.statusCode == 200){
      print("请求成功");
      return true;
    }
    else{
      print('请求失败');
    }
  }
  post_aiimage(String url,String text) async{
    final response = await http.post(
        Uri.parse(url),
        headers:{'Content-Type':'application/json'},
        body: json.encode({
          "text":text
        })
    );
    if(response.statusCode == 200){
      print("请求成功");
      return json.decode(response.body)['data'];
    }
    else{
      print('请求失败');
    }
  }
  post_active(String url,String code) async{
    final response = await http.post(
        Uri.parse(url),
    );
    if(response.statusCode == 200){
      print("请求成功");
      print(response.body);
      return true;
      // if(response.body.contains("验证数据")){
      //   final save_data = await SharedPreferences.getInstance();
      //   save_data.setString("code", code);
      //   save_data.setBool("isactive", true);
      //   return true;
      // }
    }
    else{
      print('请求失败');
    }
  }
  get_excel(String url,String name) async{
    final response = await http.get(
      Uri.parse(url),
      headers:{'Content-Type':'application/json'},
    );
    if(response.statusCode == 200){
      final directory= await getApplicationDocumentsDirectory();
      final file = File("${directory.path}/$name");
      await file.writeAsBytes(response.bodyBytes);
      print('Download complete');
      OpenFile.open(file.path);
      print("请求成功");
      return true;
    }
    else{
      print('请求失败');
    }
  }
  switch_api(String url,List list_type,String code) async{
    final response = await http.post(
      Uri.parse(url),
      headers:{'Content-Type':'application/json'},
      body:json.encode({
        "list_type":list_type,
        "code":code
      })
    );
    if(response.statusCode == 200){
      final data = json.decode(response.body);
      print("data:$data");
      return json.decode(response.body);
    }
    else{
      print('请求失败');
    }
  }
  post_audio(var url,var text,var audiopath) async{
    final request = http.MultipartRequest("POST", Uri.parse(url));
    request..fields['text'] = text
           ..files.add(await http.MultipartFile.fromPath('file',audiopath));
    final response = await request.send();
    if(response.statusCode == 200){
      final data = await response.stream.bytesToString();
      final result = json.decode(data);
      final audio_url = result['data'];
      print("获取音频地址为：$audio_url");
      print(response.statusCode);
      return audio_url;
    }
    else{
      print("获取失败");
    }
  }
}