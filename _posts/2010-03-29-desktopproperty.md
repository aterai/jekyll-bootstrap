---
layout: post
category: swing
folder: DesktopProperty
title: DesktopPropertyの変更を監視する
tags: [Toolkit, PropertyChangeListener]
author: aterai
pubdate: 2010-03-29T15:07:50+09:00
description: ToolkitにPropertyChangeListenerを追加して、ダブルクリックの速度などの変更を監視します。
image: https://lh3.googleusercontent.com/_9Z4BYR88imo/TQTKxXuJ4EI/AAAAAAAAAWg/utfOkK69KBk/s800/DesktopProperty.png
comments: true
---
## 概要
`Toolkit`に`PropertyChangeListener`を追加して、ダブルクリックの速度などの変更を監視します。

{% download https://lh3.googleusercontent.com/_9Z4BYR88imo/TQTKxXuJ4EI/AAAAAAAAAWg/utfOkK69KBk/s800/DesktopProperty.png %}

## サンプルコード
<pre class="prettyprint"><code>Toolkit.getDefaultToolkit().addPropertyChangeListener(
    "awt.multiClickInterval", new PropertyChangeListener() {
  @Override public void propertyChange(PropertyChangeEvent e) {
    System.out.println("----\n"+e.getPropertyName());
    System.out.println(Toolkit.getDefaultToolkit().getDesktopProperty(e.getPropertyName()));
  }
});
</code></pre>

## 解説
上記のサンプルでは、`Toolkit`に`PropertyChangeListener`を追加して、ダブルクリックの速度と、`Windows`環境での画面の配色(画面のプロパティ、デザイン、配色の規定(青)、オリーブグリーン、シルバー)の変更を監視しています。

その他のサポートされている`Windows`デスクトップ関連のプロパティー一覧は、以下のようにして取得できます。

- [Windowsデスクトップ関連のプロパティのサポート](https://docs.oracle.com/javase/jp/8/docs/technotes/guides/swing/1.4/w2k_props.html)

<!-- dummy comment line for breaking list -->

<pre class="prettyprint"><code>import java.awt.*;
public class DesktopPropertyList {
  public static void main(String[] args) {
    for (String s: (String[]) Toolkit.getDefaultToolkit().getDesktopProperty("win.propNames"))
      System.out.println(s);
  }
}
</code></pre>

## 参考リンク
- [Windowsデスクトップ関連のプロパティのサポート](https://docs.oracle.com/javase/jp/8/docs/technotes/guides/swing/1.4/w2k_props.html)
- [Swing - Should UIManager fire propertyChangeEvents here?](https://community.oracle.com/thread/1352133)

<!-- dummy comment line for breaking list -->

## コメント
- メモ: [Windows デスクトップ関連のプロパティーのサポート](https://docs.oracle.com/javase/jp/8/docs/technotes/guides/swing/1.4/w2k_props.html)の、(`TBI`)の意味を調べる。「メッセージボックスのフォントカラー」のプロパティー名は文字化け？、重複？。同じく、アイコンのサイズとアイコンの横の間隔など。 -- *aterai* 2010-03-29 (月) 15:07:50

<!-- dummy comment line for breaking list -->
