---
layout: post
category: swing
folder: ToolBarLayout
title: JToolBarでアイコンボタンを右寄せ
tags: [JToolBar, JMenuBar, BoxLayout, JButton, Focus]
author: aterai
pubdate: 2006-01-23T14:20:11+09:00
description: JToolBarでアイコンボタンを右寄せ、下寄せで表示します。
image: https://lh3.googleusercontent.com/_9Z4BYR88imo/TQTVb-HPZjI/AAAAAAAAAno/dMILsHzlipk/s800/ToolBarLayout.png
comments: true
---
## 概要
`JToolBar`でアイコンボタンを右寄せ、下寄せで表示します。

{% download https://lh3.googleusercontent.com/_9Z4BYR88imo/TQTVb-HPZjI/AAAAAAAAAno/dMILsHzlipk/s800/ToolBarLayout.png %}

## サンプルコード
<pre class="prettyprint"><code>// jlfgr-1_0.jar
String path = "/toolbarButtonGraphics/general/";
URL url1 = getClass().getResource(path + "Copy24.gif");
URL url2 = getClass().getResource(path + "Cut24.gif");
URL url3 = getClass().getResource(path + "Help24.gif");
toolbar.add(createToolbarButton(url1));
toolbar.add(createToolbarButton(url2));
toolbar.add(Box.createGlue());
toolbar.add(createToolbarButton(url3));
// ...
private static JButton createToolbarButton(URL url) {
  JButton b = new JButton(new ImageIcon(url));
  b.setRequestFocusEnabled(false);
  // or: b.setFocusPainted(false);
  return b;
}
</code></pre>

## 解説
`JToolBar`や`JMenuBar`のデフォルトレイアウトは`BoxLayout`なので、`Box.createGlue()`を間に挟むことでボタンやメニューの右寄せが可能です。

ボタンとボタンの間隔を固定値で空けたい場合は、`Box.createRigidArea`を使用します。`Box.createHorizontalStrut(...)`や`Box.createVerticalStrut(...)`を使うとツールバーの水平・垂直が切り替わった時に、余計な余白が発生する場合があります。

各アイコンは、[Java look and feel Graphics Repository](http://web.archive.org/web/20120818143859/http://java.sun.com/developer/techDocs/hi/repository/)の`jlfgr-1_0.jar`がクラスパス内に存在する場合はそこから読み込んでいます。

- - - -
`JDK 1.6`で、`JDK 1.5`のようなボタン表示(フォーカスを取得しない)にするには、`JComponent#setRequestFocusEnabled(false)`(マウスクリックではフォーカスを取得しないが、キーボードからは許可)、または、`AbstractButton#setFocusable(false)`とする必要があるようです。

![screenshot](https://lh4.googleusercontent.com/_9Z4BYR88imo/TQTVeG6fVBI/AAAAAAAAAns/II_0GGIdnNk/s800/ToolBarLayout1.png)

- マウスクリックでツールバーボタンにフォーカスが移動すると、コピーボタンを押したらテキストエディタでの文字列選択状態がクリアされたり、参考の質問のような不具合が起こる
- 参考: [Swing - JTextPane selection color problem](https://community.oracle.com/thread/1358842)の camickr さんの投稿(2008/10/25 0:34)
- `%JAVA_HOME%/demo/jfc/Notepad/src/Notepad.java`

<!-- dummy comment line for breaking list -->

## 参考リンク
- [Java look and feel Graphics Repository](http://web.archive.org/web/20120818143859/http://java.sun.com/developer/techDocs/hi/repository/)
- [Swing - Buttons like Netbeans'](https://community.oracle.com/thread/1365522)
- [Customizing Menu Layout - How to Use Menus (The Java™ Tutorials > Creating a GUI With JFC/Swing > Using Swing Components)](https://docs.oracle.com/javase/tutorial/uiswing/components/menu.html#custom)
- [JComponent#setRequestFocusEnabled(boolean) (Java Platform SE 8)](https://docs.oracle.com/javase/jp/8/docs/api/javax/swing/JComponent.html#setRequestFocusEnabled-boolean-)
- [AbstractButton#setFocusPainted(boolean) (Java Platform SE 8)](https://docs.oracle.com/javase/jp/8/docs/api/javax/swing/AbstractButton.html#setFocusPainted-boolean-)

<!-- dummy comment line for breaking list -->

## コメント
- 環境によって、上記のサンプルが右寄せにならない場合もあるようです。 -- *aterai* 2006-03-22 (水) 15:58:10
- `setRequestFocusEnabled(false)`、スクリーンショット更新。 -- *aterai* 2008-10-27 (月) 15:20:38

<!-- dummy comment line for breaking list -->
