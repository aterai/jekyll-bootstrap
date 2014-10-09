---
layout: post
category: swing
folder: FrameIcon
title: JFrameのIconを変更
tags: [JFrame, Icon, Image]
author: aterai
pubdate: 2004-08-30T05:11:06+09:00
description: JFrameのタイトルバー左に表示されているアイコンを別の画像に変更します。
comments: true
---
## 概要
`JFrame`のタイトルバー左に表示されているアイコンを別の画像に変更します。

{% download https://lh5.googleusercontent.com/_9Z4BYR88imo/TQTNO_p95yI/AAAAAAAAAac/gl0vOOoKH14/s800/FrameIcon.png %}

## サンプルコード
<pre class="prettyprint"><code>MainPanel panel = new MainPanel();
URL url = panel.getClass().getResource("16x16.png");
JFrame frame = new JFrame();
frame.setIconImage(Toolkit.getDefaultToolkit().createImage(url));
</code></pre>

## 解説
`JFrame#setIconImage`メソッドでアイコンを設定しています。

サンプルでは[GIMP](http://www.gimp.org/)を使って作成した`16x16`の透過`PNG`をアイコンとして使用しています。

## 参考リンク
- [GIMP](http://www.gimp.org/)

<!-- dummy comment line for breaking list -->

## コメント
- ~~`JDK 1.6.0`で試すとアイコンの表示が乱れる？ -- *aterai* 2006-06-29 (木) 17:57:16~~

<!-- dummy comment line for breaking list -->
