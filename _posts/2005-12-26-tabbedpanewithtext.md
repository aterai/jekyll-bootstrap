---
layout: post
category: swing
folder: TabbedPaneWithText
title: JTabbedPaneの余白に文字列を表示
tags: [JTabbedPane, FontMetrics, JLayer]
author: aterai
pubdate: 2005-12-26T12:36:53+09:00
description: JTabbedPaneの右側の余白に文字列を表示します。
image: https://lh4.googleusercontent.com/_9Z4BYR88imo/TQTUTbAqf_I/AAAAAAAAAl0/APOrWdnvDko/s800/TabbedPaneWithText.png
comments: true
---
## 概要
`JTabbedPane`の右側の余白に文字列を表示します。[Swing - JTabbedPane with non-tabbed text](https://community.oracle.com/thread/1392495)の投稿からソースコードを引用しています。

{% download https://lh4.googleusercontent.com/_9Z4BYR88imo/TQTUTbAqf_I/AAAAAAAAAl0/APOrWdnvDko/s800/TabbedPaneWithText.png %}

## サンプルコード
<pre class="prettyprint"><code>tab = new JTabbedPane() {
  @Override protected void paintComponent(Graphics g) {
    super.paintComponent(g);
    String text = "←ちょっとしたタブの説明など";
    FontMetrics fm = getFontMetrics(getFont());
    int stringWidth = fm.stringWidth(text) + 10;
    int x = getSize().width - stringWidth;
    Rectangle lastTab = getBoundsAt(getTabCount() - 1);
    int tabEnd = lastTab.x + lastTab.width;
    if (x &lt; tabEnd) {
      x = tabEnd;
    }
    g.drawString(text, x + 5, 18);
  }
};
</code></pre>

## 解説
`JTabbedPane#paintComponent`メソッドをオーバーライドして、タブコンポーネントの右側の余白に文字列を描画しています。

右端に十分な余白が無く、文字列を描画するとタブ上に重なってしまう場合は、最後のタブの横から文字列を描画するようになっています。

- - - -
`JDK 1.7.0`以降なら、`JLayer`を使用する方法もあります。

<pre class="prettyprint"><code>import java.awt.*;
import javax.swing.*;
import javax.swing.plaf.*;

public class TopRightCornerLabelLayerUITest {
  public static JComponent makeUI() {
    JTabbedPane tabs = new JTabbedPane();
    tabs.addTab("New tab1", new JLabel("1"));
    tabs.addTab("New Tab2", new JLabel("2"));
    JPanel p = new JPanel(new BorderLayout());
    p.add(new JLayer&lt;JComponent&gt;(tabs, new TopRightCornerLabelLayerUI()));
    return p;
  }
  private static void createAndShowUI() {
    JFrame f = new JFrame();
    f.setDefaultCloseOperation(WindowConstants.EXIT_ON_CLOSE);
    f.getContentPane().add(makeUI());
    f.setSize(320, 240);
    f.setLocationRelativeTo(null);
    f.setVisible(true);
  }
  public static void main(String[] args) {
    EventQueue.invokeLater(new Runnable() {
      @Override public void run() {
        createAndShowUI();
      }
    });
  }
}
class TopRightCornerLabelLayerUI extends LayerUI&lt;JComponent&gt; {
  private JLabel l = new JLabel("A Label at right corner");
  private JPanel rubberStamp = new JPanel();
  @Override public void paint(Graphics g, JComponent c) {
    super.paint(g, c);
    Dimension d = l.getPreferredSize();
    int x = c.getWidth() - d.width - 5;
    SwingUtilities.paintComponent(g, l, rubberStamp, x, 2, d.width, d.height);
  }
}
</code></pre>

## 参考リンク
- [Swing - JTabbedPane with non-tabbed text](https://community.oracle.com/thread/1392495)
- [JTabbedPaneの余白にJCheckBoxを配置](https://ateraimemo.com/Swing/TabbedPaneWithCheckBox.html)
- [JTabbedPaneの余白にJButtonを配置](https://ateraimemo.com/Swing/TabbedPaneWithButton.html)
    - `JLabel`ではなく、クリック可能な`JButton`を`JTabbedPane`に配置するサンプル

<!-- dummy comment line for breaking list -->

## コメント
