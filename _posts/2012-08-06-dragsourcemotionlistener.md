---
layout: post
category: swing
folder: DragSourceMotionListener
title: JFrameの外側でもドラッグアイコンを表示する
tags: [DragAndDrop, JWindow, ImageIcon, JFrame, JLabel]
author: aterai
pubdate: 2012-08-06T15:46:37+09:00
description: ドラッグ中のカーソル位置をDragSourceMotionListenerで取得し、そこにアイコンを追加したWindowを移動することで、JFrameの外側でもドラッグアイコンを表示します。
image: https://lh4.googleusercontent.com/-HM5QzW5AZlk/UB9iFlbSZMI/AAAAAAAABQM/fggojAo0b-E/s800/DragSourceMotionListener.png
comments: true
---
## 概要
ドラッグ中のカーソル位置を`DragSourceMotionListener`で取得し、そこにアイコンを追加した`Window`を移動することで、`JFrame`の外側でもドラッグアイコンを表示します。

{% download https://lh4.googleusercontent.com/-HM5QzW5AZlk/UB9iFlbSZMI/AAAAAAAABQM/fggojAo0b-E/s800/DragSourceMotionListener.png %}

## サンプルコード
<pre class="prettyprint"><code>final JWindow window = new JWindow();
window.add(label);
//window.setAlwaysOnTop(true);
//com.sun.awt.AWTUtilities.setWindowOpaque(window, false); // JDK 1.6.0
window.setBackground(new Color(0x0, true)); // JDK 1.7.0
DragSource.getDefaultDragSource().addDragSourceMotionListener(new DragSourceMotionListener() {
  @Override public void dragMouseMoved(DragSourceDragEvent dsde) {
    window.setLocation(dsde.getLocation());
  }
});
</code></pre>

## 解説
上記のサンプルでは、`JPanel`中に配置されているアイコンなどを設定した`JLabel`を`Drag & Drop`で別の`JPanel`(例えば親の`JFrame`が異なる場合も可)に移動できます。`JLabel`のドラッグ開始時に元の親`JPanel`からそれを削除して透明化した`Window`に移し替え、ドラッグに合わせて`Window`自体を移動しているので、`JFrame`の外でもドラッグアイコンが表示可能です。
ドラッグ中のカーソル位置取得には、`MouseMotionListener`を使用する方法もありますが、このサンプルのような`TransferHandler`を使ったドラッグでは`MouseMotionListener`でマウスイベントを取得できないので、`DefaultDragSource`に`DragSourceMotionListener`を追加してドラッグ中のカーソル位置を取得しています。

- `DragSourceDragEvent#getLocation()`で取得した位置はスクリーン座標系なので、そのまま`Window#setLocation(...)`メソッドで使用可能
- `Point pt = tgtLabel.getLocation();`で取得したドラッグ対象`JLabel`の位置は親コンポーネントの座標系なので、`SwingUtilities.convertPointToScreen(pt, parent);`で変換する必要がある

<!-- dummy comment line for breaking list -->

## 参考リンク
- [JLayerを使ってJTabbedPaneのタブの挿入位置を描画する](https://ateraimemo.com/Swing/DnDLayerTabbedPane.html)

<!-- dummy comment line for breaking list -->

## コメント
- `OSX`などの場合はどうなるか不明(テストしていない)。 -- *aterai* 2012-08-06 (月) 15:50:35
- `OSX`でも表示しましたよ。ただクリックした時にアイコン周りに枠が表示されるのですが、その位置がアイコンとずれてます -- *nsby* 2012-08-07 (火) 11:04:46
    - ありがとうございます。[Bug ID: 4874070 invoking DragSource's startDrag with an Image renders no image on drag](https://bugs.openjdk.java.net/browse/JDK-4874070)あたりの修正の詳しい内容がよく分かっていないので、逆に`Mac OS X`では競合する(二重になる)のでは？と思っていました。「アイコン周りの枠」はオフセットを変更するか、クリックした時点で`JPanel`からは削除してしまえば、何とかなるかもしれません。 -- *aterai* 2012-08-07 (火) 14:19:12
- `Web Start`で起動すると、`window.setAlwaysOnTop(true);`で`AccessControlException`が発生するのを修正。 -- *aterai* 2012-12-07 (金) 18:20:23
- ドラッグ中カーソルが点滅するので、`dragMouseMoved`内で無駄に`Window#setVisible(true);`を実行しないように修正(`TransferHandler#getSourceActions(...)`内でドラッグ開始時に一回だけ実行する)。 -- *aterai* 2013-10-25 (金) 18:04:11

<!-- dummy comment line for breaking list -->
