---
layout: post
title: DesktopPropertyの変更を監視する
category: swing
folder: DesktopProperty
tags: [Toolkit, PropertyChangeListener]
author: aterai
---

Posted by [aterai](http://terai.xrea.jp/aterai.html) at 2010-03-29

## DesktopPropertyの変更を監視する
`Toolkit`に`PropertyChangeListener`を追加して、ダブルクリックの速度などの変更を監視します。

- {% jnlp %}
- {% jar %}
- {% src %}
- {% svn %}

<!-- dummy comment line for breaking list -->

![screenshot](https://lh3.googleusercontent.com/_9Z4BYR88imo/TQTKxXuJ4EI/AAAAAAAAAWg/utfOkK69KBk/s800/DesktopProperty.png)

### サンプルコード
<pre class="prettyprint"><code>Toolkit.getDefaultToolkit().addPropertyChangeListener(
    "awt.multiClickInterval", new PropertyChangeListener() {
  @Override public void propertyChange(PropertyChangeEvent e) {
    System.out.println("----\n"+e.getPropertyName());
    System.out.println(Toolkit.getDefaultToolkit().getDesktopProperty(e.getPropertyName()));
  }
});
</code></pre>

### 解説
上記のサンプルでは、`Toolkit`に`PropertyChangeListener`を追加して、ダブルクリックの速度と、`Windows`環境での画面の配色(画面のプロパティ、デザイン、配色の規定(青)、オーブ グリーン、シルバー)の変更を監視しています。

その他、サポートされている`Windows`デスクトップ関連のプロパティー一覧は、以下のようにして取得することができます。

- [Windows デスクトップ関連のプロパティーのサポート](http://docs.oracle.com/javase/jp/6/technotes/guides/swing/1.4/w2k_props.html)のサンプルより

<!-- dummy comment line for breaking list -->

<pre class="prettyprint"><code>import java.awt.*;
public class DesktopPropertyList {
  public static void main(String[] args) {
    for(String s:(String[])Toolkit.getDefaultToolkit().getDesktopProperty("win.propNames"))
      System.out.println(s);
  }
}
</code></pre>

### 参考リンク
- [Windows デスクトップ関連のプロパティーのサポート](http://docs.oracle.com/javase/jp/6/technotes/guides/swing/1.4/w2k_props.html)
- [Swing - Should UIManager fire propertyChangeEvents here?](https://forums.oracle.com/message/5698661)

<!-- dummy comment line for breaking list -->

### コメント
- メモ: [Windows デスクトップ関連のプロパティーのサポート](http://docs.oracle.com/javase/jp/6/technotes/guides/swing/1.4/w2k_props.html)の、(`TBI`)の意味を調べる。「メッセージボックスのフォントカラー」のプロパティー名は文字化け？、重複？。同じく、アイコンのサイズとアイコンの横の間隔など。 -- [aterai](http://terai.xrea.jp/aterai.html) 2010-03-29 (月) 15:07:50

<!-- dummy comment line for breaking list -->

