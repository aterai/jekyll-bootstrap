---
layout: post
category: swing
folder: CreateFont
title: Fontをファイルから取得
tags: [Font, JTextArea]
author: aterai
pubdate: 2005-03-07T02:07:13+09:00
description: 独自フォント(mona.ttf)をファイルから読み込み、ASCII artを表示します。
image: https://lh6.googleusercontent.com/_9Z4BYR88imo/TQTKOUJYB7I/AAAAAAAAAVo/K2rl3dXD4ic/s800/CreateFont.png
comments: true
---
## 概要
独自フォント(`mona.ttf`)をファイルから読み込み、`ASCII art`を表示します。

{% download https://lh6.googleusercontent.com/_9Z4BYR88imo/TQTKOUJYB7I/AAAAAAAAAVo/K2rl3dXD4ic/s800/CreateFont.png %}

## サンプルコード
<pre class="prettyprint"><code>Font makeFont(URL url) {
    Font font = null;
    try (InputStream is = url.openStream()) {
        font = Font.createFont(Font.TRUETYPE_FONT, is).deriveFont(12f);
    } catch (IOException | FontFormatException ex) {
        ex.printStackTrace();
    }
    return font;
}
//Font makeFont(URL url) {
//  Font font = null;
//  InputStream is = null;
//  try {
//    is = url.openStream();
//    font = (Font.createFont(Font.TRUETYPE_FONT, is)).deriveFont(12f);
//    is.close();
//  } catch (IOException ioe) {
//    ioe.printStackTrace();
//  } catch (FontFormatException ffe) {
//    ffe.printStackTrace();
//  } finally {
//    if (is != null) {
//      try {
//        is.close();
//      } catch (IOException ioex) {
//        ioex.printStackTrace();
//      }
//    }
//  }
//  return font;
//}
</code></pre>

## 解説
上記のサンプルでは、`Font.createFont(...)`メソッドでフォントを作成しています。

## 参考リンク
- [Font (Java Platform SE 8)](https://docs.oracle.com/javase/jp/8/docs/api/java/awt/Font.html#createFont-int-java.io.File-)
- [モナーフォント](http://monafont.sourceforge.net/index.html)
- [Swing (Archive) - Loading TYPE1 fonts with JRE 1.5.0](https://community.oracle.com/thread/1483177)

<!-- dummy comment line for breaking list -->

## コメント
- `JDK 1.5.0_01`でずれる？ -- *aterai* 2005-03-07 11:19:11 (月)
    - 応急処置済み -- *aterai* 2005-03-07 11:32:44 (月)
- メモ: [Bug ID: 6313541 Fonts loaded with createFont cannot be converted into FontUIResource](http://bugs.java.com/bugdatabase/view_bug.do?bug_id=6313541) -- *aterai* 2006-05-25 (木) 23:34:18

<!-- dummy comment line for breaking list -->
