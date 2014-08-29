---
layout: post
title: WindowAncestor(親ウィンドウ)の取得
category: swing
folder: WindowAncestor
tags: [JFrame, Window]
author: aterai
comments: true
---

Posted by [aterai](http://terai.xrea.jp/aterai.html) at 2005-05-09

## WindowAncestor(親ウィンドウ)の取得
`SwingUtilities.getWindowAncestor()`などで、親ウィンドウを取得します。

{% download https://lh4.googleusercontent.com/_9Z4BYR88imo/TQTWr-a0yaI/AAAAAAAAApo/Wm-nQMxDh4s/s800/WindowAncestor.png %}

### サンプルコード
<pre class="prettyprint"><code>JButton button = new JButton(new AbstractAction("フレームのタイトルを表示") {
  @Override public void actionPerformed(ActionEvent e) {
    JButton btn  = (JButton)e.getSource();
    JFrame f = (JFrame)SwingUtilities.getWindowAncestor(btn);
    //JFrame f = (JFrame)btn.getTopLevelAncestor();
    //JFrame f = (JFrame)JOptionPane.getFrameForComponent(btn);
    JOptionPane.showMessageDialog(f, "parentFrame.getTitle(): "+f.getTitle(),
                                  "title", JOptionPane.INFORMATION_MESSAGE);
  }
}));
</code></pre>

### 解説
自分(コンポーネント)の最初の上位ウィンドウ(親ウィンドウ)を取得します。

- [SwingUtilities.getWindowAncestor(Component c)](http://docs.oracle.com/javase/jp/6/api/javax/swing/SwingUtilities.html#getWindowAncestor%28java.awt.Component%29)
    - `SwingUtilities.windowForComponent(Component c)`は、`getWindowAncestor`をラップしただけのメソッド
    - 親の`java.awt.Window`が返る
    - 親`Window`が無い場合は、`null`

<!-- dummy comment line for breaking list -->

- [SwingUtilities.getRoot(Component c)](http://docs.oracle.com/javase/jp/6/api/javax/swing/SwingUtilities.html#getRoot%28java.awt.Component%29)
    - 親のコンポーネント(`java.awt.Window`または`java.awt.Applet`)が返る
        - `Window`の場合は、`c.getParent()`で見つかる最初の上位`Window`オブジェクトだが、`Applet`の場合は、`JComponent#getTopLevelAncestor()`とは異なり、最後の上位`Applet`オブジェクト
    - どちらも存在しない場合は、`null`

<!-- dummy comment line for breaking list -->

- [JComponent#getTopLevelAncestor()](http://docs.oracle.com/javase/jp/6/api/javax/swing/JComponent.html#getTopLevelAncestor%28%29)
    - 自身の親コンテナ(`java.awt.Window`または`java.awt.Applet`)が返る
    - 親コンテナが無い場合は、`null`
    - 下のコメント参照

<!-- dummy comment line for breaking list -->

- [JOptionPane.getFrameForComponent(Component parentComponent)](http://docs.oracle.com/javase/jp/6/api/javax/swing/JOptionPane.html#getFrameForComponent%28java.awt.Component%29)
    - 親の`java.awt.Frame`が返る
    - 有効な親`Frame`が無い場合は`JOptionPane.getRootFrame()`で、非表示にしている`TookKit Private`なフレームが返る
    - `JOptionPane`用？

<!-- dummy comment line for breaking list -->

### 参考リンク
- [SwingUtilities.getRoot(Component c)](http://docs.oracle.com/javase/jp/6/api/javax/swing/SwingUtilities.html#getRoot%28java.awt.Component%29) を追加
    - via: [Java/Swing: Obtain Window/JFrame from inside a JPanel - Stack Overflow](http://stackoverflow.com/questions/9650874/java-swing-obtain-window-jframe-from-inside-a-jpanel)

<!-- dummy comment line for breaking list -->

### コメント
- `JComponent#getTopLevelAncestor()`でもほぼ同じ内容が取得できるような感じですね（自分自身からスタートするか、親からスタートするかの違いはあるようですが）。ただ、この場合、`Window`の他に`Applet`が戻される場合もあるようですが。 -- [syo](http://terai.xrea.jp/syo.html) 2006-08-24 (木) 17:07:25
    - 補足ありがとうございます。`Window`か`Applet`か気にする必要が無いのは便利そうですね。 -- [aterai](http://terai.xrea.jp/aterai.html) 2006-08-25 (金) 12:46:43

<!-- dummy comment line for breaking list -->

