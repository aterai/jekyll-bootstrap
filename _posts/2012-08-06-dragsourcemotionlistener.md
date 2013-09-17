---
layout: post
title: JFrameの外側でもドラッグアイコンを表示する
category: swing
folder: DragSourceMotionListener
tags: [DragAndDrop, JWindow, ImageIcon, JFrame]
author: aterai
comments: true
---

Posted by [aterai](http://terai.xrea.jp/aterai.html) at 2012-08-06

## JFrameの外側でもドラッグアイコンを表示する
ドラッグ中のカーソル位置を`DragSourceMotionListener`で取得し、そこにアイコンを追加した`Window`を移動することで、`JFrame`の外側でもドラッグアイコンを表示します。

- {% jnlp %}
- {% jar %}
- {% src %}
- {% svn %}

<!-- dummy comment line for breaking list -->

![screenshot](https://lh4.googleusercontent.com/-HM5QzW5AZlk/UB9iFlbSZMI/AAAAAAAABQM/fggojAo0b-E/s800/DragSourceMotionListener.png)

### サンプルコード
<pre class="prettyprint"><code>final JWindow window = new JWindow();
window.add(label);
window.setAlwaysOnTop(true);
com.sun.awt.AWTUtilities.setWindowOpaque(window, false); // JDK 1.6.0
//window.setBackground(new Color(0, true)); // JDK 1.7.0
DragSource.getDefaultDragSource().addDragSourceMotionListener(new DragSourceMotionListener() {
  @Override public void dragMouseMoved(DragSourceDragEvent dsde) {
    window.setLocation(dsde.getLocation());
    window.setVisible(true);
  }
});
</code></pre>

### 解説
上記のサンプルでは、`JPanel`中に配置した`JLabel`(アイコン)を`Drag & Drop`で別の`JPanel`など(親の`JFrame`が異なる場合も可)に移動することができます。ドラッグ中の`JLabel`は透明化した`Window`に配置され、ドラッグに合わせてその`Window`を移動しているので、`JFrame`の外でもドラッグアイコンが表示可能になっています。
ドラッグ中のカーソル位置取得には、`MouseMotionListener`を使用する方法もありますが、このサンプルのような`TransferHandler`を使ったドラッグでは`MouseMotionListener`でマウスイベントを取得することができないので、`DefaultDragSource`に`DragSourceMotionListener`を追加してドラッグ中のカーソル位置を取得しています。

- 注: `DragSourceDragEvent#getLocation()`で取得できる位置は、スクリーン上でのマウス位置なので、`MouseEvent#getPoint()`の場合のように`SwingUtilities.convertPointToScreen(pt, c);`で変換しなくて良い

<!-- dummy comment line for breaking list -->

### 参考リンク
- [JLayerを使ってJTabbedPaneのタブの挿入位置を描画する](http://terai.xrea.jp/Swing/DnDLayerTabbedPane.html)

<!-- dummy comment line for breaking list -->

### コメント
- `OSX`などの場合はどうなるか不明(テストしていない)。 -- [aterai](http://terai.xrea.jp/aterai.html) 2012-08-06 (月) 15:50:35
- `OSX`でも表示しましたよ。ただクリックした時にアイコン周りに枠が表示されるのですが、その位置がアイコンとずれてます -- [nsby](http://terai.xrea.jp/nsby.html) 2012-08-07 (火) 11:04:46
    - ありがとうございます。[Bug ID: 4874070 invoking DragSource's startDrag with an Image renders no image on drag](http://bugs.sun.com/bugdatabase/view_bug.do?bug_id=4874070)あたりの修正の詳しい内容がよく分かっていないので、逆に`Mac OS X`では競合する(二重になる)のでは？と思っていました。「アイコン周りの枠」はオフセットを変更するか、クリックした時点で`JPanel`からは削除してしまえば、何とかなるかもしれません。 -- [aterai](http://terai.xrea.jp/aterai.html) 2012-08-07 (火) 14:19:12
- `Web Start`で起動すると、`window.setAlwaysOnTop(true);`で`AccessControlException`が発生するのを修正。 -- [aterai](http://terai.xrea.jp/aterai.html) 2012-12-07 (金) 18:20:23

<!-- dummy comment line for breaking list -->

