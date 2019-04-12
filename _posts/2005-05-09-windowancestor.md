---
layout: post
category: swing
folder: WindowAncestor
title: WindowAncestor(親ウィンドウ)の取得
tags: [JFrame, Window]
author: aterai
pubdate: 2005-05-09T21:28:35+09:00
description: SwingUtilities.getWindowAncestor()などで、親ウィンドウを取得します。
image: https://lh4.googleusercontent.com/_9Z4BYR88imo/TQTWr-a0yaI/AAAAAAAAApo/Wm-nQMxDh4s/s800/WindowAncestor.png
comments: true
---
## 概要
`SwingUtilities.getWindowAncestor()`などで、親ウィンドウを取得します。

{% download https://lh4.googleusercontent.com/_9Z4BYR88imo/TQTWr-a0yaI/AAAAAAAAApo/Wm-nQMxDh4s/s800/WindowAncestor.png %}

## サンプルコード
<pre class="prettyprint"><code>JButton button = new JButton(new AbstractAction("フレームのタイトルを表示") {
  @Override public void actionPerformed(ActionEvent e) {
    JButton btn  = (JButton) e.getSource();
    JFrame f = (JFrame) SwingUtilities.getWindowAncestor(btn);
    // JFrame f = (JFrame) btn.getTopLevelAncestor();
    // JFrame f = (JFrame) JOptionPane.getFrameForComponent(btn);
    JOptionPane.showMessageDialog(
        f, "parentFrame.getTitle(): " + f.getTitle(),
        "title", JOptionPane.INFORMATION_MESSAGE);
  }
}));
</code></pre>

## 解説
自分(コンポーネント)の最初の上位ウィンドウ(親ウィンドウ)を取得します。

- [SwingUtilities.getWindowAncestor(Component c)](https://docs.oracle.com/javase/jp/8/docs/api/javax/swing/SwingUtilities.html#getWindowAncestor-java.awt.Component-)
    - `SwingUtilities.windowForComponent(Component c)`は、この`getWindowAncestor`をラップしただけのメソッド
    - 親の`java.awt.Window`が返る
    - 親`Window`が無い場合は、`null`が返る
    - 引数の`Component`自体が`Window`の場合、その`Window`のオーナー`Window`が返る
        - オーナー`Window`が`null`の場合は、`null`が返る
- [SwingUtilities.getRoot(Component c)](https://docs.oracle.com/javase/jp/8/docs/api/javax/swing/SwingUtilities.html#getRoot-java.awt.Component-)
    - 親の`Component`(`java.awt.Window`または`java.awt.Applet`)が返る
        - `Window`の場合は、`c.getParent()`で見つかる最初の上位`Window`オブジェクトだが、`Applet`の場合は、`JComponent#getTopLevelAncestor()`とは異なり、最後の上位`Applet`オブジェクト
    - どちらも存在しない場合は、`null`
    - 引数の`Component`自体が`Window`の場合は、そのまま自身が返る
- [JComponent#getTopLevelAncestor()](https://docs.oracle.com/javase/jp/8/docs/api/javax/swing/JComponent.html#getTopLevelAncestor--)
    - 自身の親`Container`(`java.awt.Window`または`java.awt.Applet`)が返る
    - 親`Container`が無い場合は、`null`
    - `java.awt.Window`または`java.awt.Applet`から呼ばれた場合は、そのまま自身が返る
    - 下のコメント参照

<!-- dummy comment line for breaking list -->

- [JOptionPane.getFrameForComponent(Component parentComponent)](https://docs.oracle.com/javase/jp/8/docs/api/javax/swing/JOptionPane.html#getFrameForComponent-java.awt.Component-)
    - 親の`java.awt.Frame`が返る
    - 有効な親`Frame`が無い場合は`JOptionPane.getRootFrame()`で、非表示にしている`TookKit Private`なフレームが返る
    - `JOptionPane`用？

<!-- dummy comment line for breaking list -->

## 参考リンク
- [SwingUtilities.getRoot(Component c)](https://docs.oracle.com/javase/jp/8/docs/api/javax/swing/SwingUtilities.html#getRoot-java.awt.Component-) を追加
    - via: [Java/Swing: Obtain Window/JFrame from inside a JPanel - Stack Overflow](https://stackoverflow.com/questions/9650874/java-swing-obtain-window-jframe-from-inside-a-jpanel)

<!-- dummy comment line for breaking list -->

## コメント
- `JComponent#getTopLevelAncestor()`でもほぼ同じ内容が取得できるような感じですね（自分自身からスタートするか、親からスタートするかの違いはあるようですが）。ただ、この場合、`Window`の他に`Applet`が戻される場合もあるようですが。 -- *syo* 2006-08-24 (木) 17:07:25
    - 補足ありがとうございます。`Window`か`Applet`か気にする必要が無いのは便利そうですね。 -- *aterai* 2006-08-25 (金) 12:46:43

<!-- dummy comment line for breaking list -->
