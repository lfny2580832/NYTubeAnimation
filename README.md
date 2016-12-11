# NYTubeAnimation
页面切换指示动画

动画解析教程：http://www.jianshu.com/p/8a569dfd1c4b    

效果图：


![gif](https://github.com/lfny2580832/NYTubeAnimation/blob/master/demo.gif)

分解图：


![分解图](https://github.com/lfny2580832/NYTubeAnimation/blob/master/分解图.png)

#实现
###属性与实例变量
下图属性与实例变量位置及命名只是个人习惯，方便开发时自己查看，其中所有点都是根据上面的参考图来命名的，大家可以对照查看：

![变量.png](http://upload-images.jianshu.io/upload_images/2478094-62dd4821089c7eb8.png?imageMogr2/auto-orient/strip%7CimageView2/2/w/1240)

看起来一脸懵逼？没关系，我会将每个分解出来的模块完整动画向大家展示出来。由于代码有点多有点复杂，就直接以图片形式像大家展示。这其中大部分都只是很多简单的动画，但将他们组合起来就不一样啦！

###速度控制点—dynamic_Q_d和dynamic_Q2_d
</br>
这两个点来控制在不同阶段的速度，只需改变自增量即可，逻辑稍稍复杂。
![dynamic_Q_d.png](http://upload-images.jianshu.io/upload_images/2478094-0dbb21cbf99e582d.png?imageMogr2/auto-orient/strip%7CimageView2/2/w/1240)
![dynamic_Q2_d.png](http://upload-images.jianshu.io/upload_images/2478094-2ea7879e37321487.png?imageMogr2/auto-orient/strip%7CimageView2/2/w/1240)

###左边的圆弧— leftSemiShape
</br>
![leftSemiShape.gif](http://upload-images.jianshu.io/upload_images/2478094-a9bff92cbba0f9b4.gif?imageMogr2/auto-orient/strip)
![leftSemiShape.png](http://upload-images.jianshu.io/upload_images/2478094-1befba29cc5bdf14.png?imageMogr2/auto-orient/strip%7CimageView2/2/w/1240)

###主体矩形区域—maintubeShape
</br>
![mainTubeShape.gif](http://upload-images.jianshu.io/upload_images/2478094-45793b0accbb5b08.gif?imageMogr2/auto-orient/strip)
![mainTubeShape.png](http://upload-images.jianshu.io/upload_images/2478094-dc23f0b8472cffa0.png?imageMogr2/auto-orient/strip%7CimageView2/2/w/1240)

###火山形状—volcanoShape
</br>
![volcanoShape.gif](http://upload-images.jianshu.io/upload_images/2478094-a76ad44f8da20396.gif?imageMogr2/auto-orient/strip)
火山形状也是整个动画中最复杂的一部分，需要一些简单的计算，下面附上计算使用的参考图：
![火山形状参考图.png](http://upload-images.jianshu.io/upload_images/2478094-39455089151365da.png?imageMogr2/auto-orient/strip%7CimageView2/2/w/1240)
我们可以根据Q点移动的距离（dynamic_Q2_d）计算出b夹角，再通过UIBeizerPath画出相应的形状：
![volcanoShape.png](http://upload-images.jianshu.io/upload_images/2478094-bdddd89cfa6080cf.png?imageMogr2/auto-orient/strip%7CimageView2/2/w/1240)

###白块右方圆形—rightCircleShape
</br>
![rightCircleShape.gif](http://upload-images.jianshu.io/upload_images/2478094-b614100d8e35452a.gif?imageMogr2/auto-orient/strip)
![rightCircleShape.png](http://upload-images.jianshu.io/upload_images/2478094-8b32f7c2e6ebb0db.png?imageMogr2/auto-orient/strip%7CimageView2/2/w/1240)

###尾部圆形形状—tailCircleShape
</br>
![tailCircleShape.gif](http://upload-images.jianshu.io/upload_images/2478094-170937cc63cd6d13.gif?imageMogr2/auto-orient/strip)
![tailCircleShape.png](http://upload-images.jianshu.io/upload_images/2478094-e46e62afd6d5dd14.png?imageMogr2/auto-orient/strip%7CimageView2/2/w/1240)

###管道形状—tubeShape
</br>
![tubeShape.gif](http://upload-images.jianshu.io/upload_images/2478094-cfef568e2bdd6444.gif?imageMogr2/auto-orient/strip)
![tubeShape.png](http://upload-images.jianshu.io/upload_images/2478094-e955f04354127b3a.png?imageMogr2/auto-orient/strip%7CimageView2/2/w/1240)

###背景形状—wholeShape
</br>
![wholeShape.png](http://upload-images.jianshu.io/upload_images/2478094-2959933d04a768c2.png?imageMogr2/auto-orient/strip%7CimageView2/2/w/1240)
背景形状只需要将上方所有图形拼合起来并扩大一圈即可，在此就不附代码了。

###拼合
</br>
![整体效果.gif](http://upload-images.jianshu.io/upload_images/2478094-e3d936df894df18f.gif?imageMogr2/auto-orient/strip)
