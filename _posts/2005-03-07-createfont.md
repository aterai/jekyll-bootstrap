---
layout: post
title: Fontをファイルから取得
category: swing
folder: CreateFont
tags: [Font, JTextArea]
author: aterai
---

Posted by [aterai](http://terai.xrea.jp/aterai.html) at 2005-03-07

## Fontをファイルから取得
独自フォント(`mona.ttf`)をファイルから読み込み、`ASCII art`を表示します。

- {% jnlp %}
- {% jar %}
- {% src %}
- {% svn %}

<!-- dummy comment line for breaking list -->

![screenshot](http://lh6.ggpht.com/_9Z4BYR88imo/TQTKOUJYB7I/AAAAAAAAAVo/K2rl3dXD4ic/s800/CreateFont.png)

### サンプルコード
<pre class="prettyprint"><code>Font makeFont(URL url) {
  Font font = null;
  InputStream is = null;
  try {
    is = url.openStream();
    font = (Font.createFont(Font.TRUETYPE_FONT, is)).deriveFont(12.0f);
    is.close();
  }catch(IOException ioe) {
    ioe.printStackTrace();
  }catch(FontFormatException ffe) {
    ffe.printStackTrace();
  }finally{
    if(is!=null) {
      try{
        is.close();
      }catch(IOException ioex) {
        ioex.printStackTrace();
      }
    }
  }
  return font;
}
</code></pre>

### 解説
`Font.createFont`メソッドでフォントを作成しています。

上記のサンプルでは、[モナーフォント](http://monafont.sourceforge.net/index.html)を使用しています。

### 参考リンク
- [モナーフォント](http://monafont.sourceforge.net/index.html)
- [Swing (Archive) - Loading TYPE1 fonts with JRE 1.5.0](https://forums.oracle.com/forums/thread.jspa?threadID=1481177)

<!-- dummy comment line for breaking list -->

### コメント
- `JDK 1.5.0_01`でずれる？ -- [aterai](http://terai.xrea.jp/aterai.html) 2005-03-07 11:19:11 (月)
- 応急処置済み -- [aterai](http://terai.xrea.jp/aterai.html) 2005-03-07 11:32:44 (月)
- メモ:[Bug ID: 6313541 Fonts loaded with createFont cannot be converted into FontUIResource](http://bugs.sun.com/bugdatabase/view_bug.do?bug_id=6313541) -- [aterai](http://terai.xrea.jp/aterai.html) 2006-05-25 (木) 23:34:18

<!-- dummy comment line for breaking list -->

