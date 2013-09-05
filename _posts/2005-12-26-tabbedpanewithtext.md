---
layout: post
title: JTabbedPaneの余白に文字列を表示
category: swing
folder: TabbedPaneWithText
tags: [JTabbedPane, FontMetrics, JLayer]
author: aterai
---

Posted by [aterai](http://terai.xrea.jp/aterai.html) at 2005-12-26

## JTabbedPaneの余白に文字列を表示
`JTabbedPane`の右側の余白に文字列を表示します。[Swing - JTabbedPane with non-tabbed text](https://forums.oracle.com/forums/thread.jspa?threadID=1390495)の投稿からソースコードを引用しています。

- {% jnlp %}
- {% jar %}
- {% src %}
- {% svn %}

<!-- dummy comment line for breaking list -->

![screenshot](http://lh4.ggpht.com/_9Z4BYR88imo/TQTUTbAqf_I/AAAAAAAAAl0/APOrWdnvDko/s800/TabbedPaneWithText.png)

### サンプルコード
<pre class="prettyprint"><code>tab = new JTabbedPane() {
  @Override protected void paintComponent(Graphics g) {
    super.paintComponent(g);
    String text = "←ちょっとしたタブの説明など";
    FontMetrics fm = getFontMetrics(getFont());
    int stringWidth = fm.stringWidth(text)+10;
    int x = getSize().width-stringWidth;
    Rectangle lastTab = getUI().getTabBounds(this, getTabCount()-1);
    int tabEnd = lastTab.x + lastTab.width;
    if(x&lt;tabEnd) x = tabEnd;
    g.drawString(text, x+5, 18);
  }
};
</code></pre>

### 解説
`JTabbedPane#paintComponent`メソッドをオーバーライドして、タブコンポーネントの右側の余白に文字列を描画しています。

右端に十分な余白が無く、文字列を描画するとタブ上に重なってしまう場合は、最後のタブの横から文字列を描画するようになっています。

- - - -
`JDK 1.7.0`の`JLayer`を使用する場合は、以下のような方法があります。

<pre class="prettyprint"><code>import java.awt.*;
import javax.swing.*;
import javax.swing.plaf.*;

public class TopRightCornerLabelLayerUITest {
  public static JComponent makeUI() {
    JTabbedPane tab = new JTabbedPane();
    tab.addTab("New tab1", new JLabel("1"));
    tab.addTab("New Tab2", new JLabel("2"));
    JPanel p = new JPanel(new BorderLayout());
    p.add(new JLayer&lt;JComponent&gt;(tab, new TopRightCornerLabelLayerUI()));
    return p;
  }
  private static void createAndShowUI() {
    JFrame f = new JFrame();
    f.setDefaultCloseOperation(JFrame.EXIT_ON_CLOSE);
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

### 参考リンク
- [Swing - JTabbedPane with non-tabbed text](https://forums.oracle.com/forums/thread.jspa?threadID=1390495)
- [JTabbedPaneの余白にJCheckBoxを配置](http://terai.xrea.jp/Swing/TabbedPaneWithCheckBox.html)

<!-- dummy comment line for breaking list -->

### コメント