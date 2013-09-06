---
layout: post
title: JToolBarでアイコンボタンを右寄せ
category: swing
folder: ToolBarLayout
tags: [JToolBar, BoxLayout, JButton, Focus]
author: aterai
---

Posted by [aterai](http://terai.xrea.jp/aterai.html) at 2006-01-23

## JToolBarでアイコンボタンを右寄せ
`JToolBar`でアイコンボタンを右寄せ、下寄せで表示します。

- {% jnlp %}
- {% jar %}
- {% src %}
- {% svn %}

<!-- dummy comment line for breaking list -->

![screenshot](https://lh3.googleusercontent.com/_9Z4BYR88imo/TQTVb-HPZjI/AAAAAAAAAno/dMILsHzlipk/s800/ToolBarLayout.png)

### サンプルコード
<pre class="prettyprint"><code>String path = "/toolbarButtonGraphics/general/";
URL url1 = getClass().getResource(path+"Copy24.gif");
URL url2 = getClass().getResource(path+"Cut24.gif");
URL url3 = getClass().getResource(path+"Help24.gif");
toolbar.add(createToolbarButton(url1));
toolbar.add(createToolbarButton(url2));
toolbar.add(Box.createGlue());
toolbar.add(createToolbarButton(url3));
</code></pre>
<pre class="prettyprint"><code>private static JButton createToolbarButton(URL url) {
  JButton b = new JButton(new ImageIcon(url));
  b.setRequestFocusEnabled(false);
  return b;
}
</code></pre>

### 解説
`JToolBar`のデフォルトレイアウトは`BoxLayout`なので、`Box.createGlue`をアイコンボタンの間に挟むことで右寄せをしています。

ボタンとボタンの間隔を固定値で空けたい場合は、`Box.createRigidArea`を使用します。`Box.createHorizontalStrut`や`Box.createVerticalStrut`を使うとツールバーが水平垂直に切り替わった時に、余計な余白が出来てしまうことがあります。

~~ツールバーが垂直になった場合のことも考えて、`VerticalGlue`も一緒に挿入していますが、特に問題ないようです。~~

アイコンは、[Java look and feel Graphics Repository](http://java.sun.com/developer/techDocs/hi/repository/)の`jlfgr-1_0.jar`から読み込んでいます。

- - - -

![screenshot](https://lh4.googleusercontent.com/_9Z4BYR88imo/TQTVeG6fVBI/AAAAAAAAAns/II_0GGIdnNk/s800/ToolBarLayout1.png)

`JDK 1.6`で、`JDK 1.5`のようなボタン表示(フォーカスを取得しない)にするには、`JButton#setRequestFocusEnabled(false)`(マウスクリックではフォーカスを取得しないが、キーボードからは許可)、または、`JButton#setFocusable(false)`とする必要があるようです。

- マウスクリックでツールバーボタンにフォーカスが移動すると、コピーボタンを押したらテキストエディタでの文字列選択状態がクリアされたり、参考の質問のような不具合が起こる
- 参考: [Swing - JTextPane selection color problem](https://forums.oracle.com/thread/1358842)の camickr さんの投稿(2008/10/25 0:34)
- `%JAVA_HOME%\demo\jfc\Notepad\src\Notepad.java`

<!-- dummy comment line for breaking list -->

### 参考リンク
- [Java look and feel Graphics Repository](http://java.sun.com/developer/techDocs/hi/repository/)
- [Swing - Buttons like Netbeans'](https://forums.oracle.com/thread/1365522)

<!-- dummy comment line for breaking list -->

### コメント
- 環境によって、上記のサンプルが右寄せにならない場合もあるようです。 -- [aterai](http://terai.xrea.jp/aterai.html) 2006-03-22 (水) 15:58:10
- `setRequestFocusEnabled(false)`、スクリーンショット更新。 -- [aterai](http://terai.xrea.jp/aterai.html) 2008-10-27 (月) 15:20:38

<!-- dummy comment line for breaking list -->

