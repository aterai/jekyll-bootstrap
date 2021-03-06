---
layout: post
category: swing
folder: ComputeTitleWidth
title: JInternalFrameのタイトル文字列幅を取得し、その値でJDesktopIconの幅を調整する
tags: [JInternalFrame, JDesktopIcon, DesktopManager, NimbusLookAndFeel]
author: aterai
pubdate: 2017-08-21T16:35:32+09:00
description: JInternalFrameのタイトル文字列幅を取得し、その値をアイコン化した場合のJDesktopIconの幅として適用します。
image: https://drive.google.com/uc?id=1cfeEsnoOvSxcwzNqjqckcWIhkgDaGxzfRA
comments: true
---
## 概要
`JInternalFrame`のタイトル文字列幅を取得し、その値をアイコン化した場合の`JDesktopIcon`の幅として適用します。

{% download https://drive.google.com/uc?id=1cfeEsnoOvSxcwzNqjqckcWIhkgDaGxzfRA %}

## サンプルコード
<pre class="prettyprint"><code>JDesktopPane desktop = new JDesktopPane();
desktop.setDesktopManager(new DefaultDesktopManager() {
  @Override public void iconifyFrame(JInternalFrame f) {
    Rectangle r = this.getBoundsForIconOf(f);
    r.width = f.getDesktopIcon().getPreferredSize().width;
    f.getDesktopIcon().setBounds(r);
    super.iconifyFrame(f);
  }
});
desktop.add(createFrame("looooooooooooong title #", 1));
desktop.add(createFrame("#", 0));
// ...
JInternalFrame f = new JInternalFrame(t + i, true, true, true, true);
f.setDesktopIcon(new JInternalFrame.JDesktopIcon(f) {
  @Override public Dimension getPreferredSize() {
    Dimension d = super.getPreferredSize();
    String title = f.getTitle();
    Font font = getFont();
    if (Objects.nonNull(font)) {
      FontMetrics fm = getFontMetrics(font);
      int titleW = SwingUtilities.computeStringWidth(fm, title);

      // @see javax/swing/plaf/basic/BasicInternalFrameTitlePane.java
      // Handler#minimumLayoutSize(Container)
      // Calculate width.
      int buttonsW = 22;
      if (f.isClosable()) {
        buttonsW += 19;
      }
      if (f.isMaximizable()) {
        buttonsW += 19;
      }
      if (f.isIconifiable()) {
        buttonsW += 19;
      }
      Insets i = getInsets();
      // 2: Magic number of gap between icons
      d.width = buttonsW + i.left + i.right + titleW + 2 + 2 + 2;
      // 27: Magic number for NimbusLookAndFeel
      d.height = Math.min(27, d.height);
      System.out.println("BasicInternalFrameTitlePane: " + d.width);
    }
    return d;
  }
//   private void testWidth() {
//     Dimension dim = getLayout().minimumLayoutSize(this);
//     System.out.println("minimumLayoutSize: " + dim.width);
//
//     int buttonsW = SwingUtils.stream(this)
//         .filter(AbstractButton.class::isInstance)
//         .mapToInt(c -&gt; c.getPreferredSize().width)
//         .sum();
//     System.out.println("Total width of all buttons: " + buttonsW);
//   }
});
</code></pre>

## 解説
- `JInternalFrame.JDesktopIcon#getPreferredSize()`メソッドをオーバーライドし、`JInternalFrame`をアイコン化した場合の推奨サイズを変更
    - [JInternalFrameをアイコン化した場合のサイズを変更する](https://ateraimemo.com/Swing/DesktopIconSize.html)
    - `JInternalFrame`のタイトル文字列を取得し、`SwingUtilities.computeStringWidth(...)`で文字列幅を計算する
        - デフォルトの`JInternalFrame`では`SwingUtilities2.stringWidth(...)`メソッドなどで省略された場合などを考慮しているが、このサンプルでは無視する
    - `ClosableButton`、`MaximizableButton`、`IconifiableButton`などの合計幅を計算する
        - `javax/swing/plaf/basic/BasicInternalFrameTitlePane.java`の`Handler#minimumLayoutSize(Container)`メソッドを参照して値を取得(`22` + `19` + `19` + `19`)
        - `JButton`を計算して`getPreferredSize().width`を合計しても値が異なる？
    - 内余白を加算して推奨サイズを返す
        - `super.getPreferredSize()`の値が初回とそれ以降で変化するため、このサンプルでは高さに固定値を使用
- `DefaultDesktopManager#iconifyFrame(JInternalFrame)`メソッドをオーバーライドして、`JInternalFrame`をアイコン化した場合の実サイズを変更
- 注:
    - このサンプルは`NimbusLookAndFeel`のみ対応で、`WindowsLookAndFeel`などには未対応

<!-- dummy comment line for breaking list -->

## 参考リンク
- [JInternalFrameをアイコン化した場合のサイズを変更する](https://ateraimemo.com/Swing/DesktopIconSize.html)
- [JInternalFrame.JDesktopIcon (Java Platform SE 8)](https://docs.oracle.com/javase/jp/8/docs/api/javax/swing/JInternalFrame.JDesktopIcon.html)
- [java - Set JInternalFrame minimised size - Stack Overflow](https://stackoverflow.com/questions/45467212/set-jinternalframe-minimised-size/45499229#45499229)

<!-- dummy comment line for breaking list -->

## コメント
