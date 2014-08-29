---
layout: post
title: JCheckBoxMenuItemのチェックアイコンを変更する
category: swing
folder: CheckBoxMenuItemIcon
tags: [JCheckBoxMenuItem, Icon, UIManager]
author: aterai
comments: true
---

Posted by [aterai](http://terai.xrea.jp/aterai.html) at 2009-09-14

## JCheckBoxMenuItemのチェックアイコンを変更する
`JCheckBoxMenuItem`のチェックアイコンを変更します。

{% download https://lh4.googleusercontent.com/_9Z4BYR88imo/TQTI5TuivhI/AAAAAAAAATg/nfren8EjliA/s800/CheckBoxMenuItemIcon.png %}

### サンプルコード
<pre class="prettyprint"><code>UIManager.put("CheckBoxMenuItem.checkIcon", new Icon() {
  @Override public void paintIcon(Component c, Graphics g, int x, int y) {
    Graphics2D g2 = (Graphics2D)g;
    g2.translate(x,y);
    ButtonModel m = ((AbstractButton)c).getModel();
    g2.setPaint(m.isSelected()?Color.ORANGE:Color.GRAY);
    g2.setRenderingHint(RenderingHints.KEY_ANTIALIASING,
                        RenderingHints.VALUE_ANTIALIAS_ON);
    g2.fillOval( 0, 2, 10, 10 );
    g2.translate(-x,-y);
  }
  @Override public int getIconWidth()  { return 14; }
  @Override public int getIconHeight() { return 14; }
});
menu.add(new JCheckBoxMenuItem("checkIcon test"));
</code></pre>

### 解説
`JCheckBox`のチェックアイコンは、`setIcon`メソッドで変更できますが、`JCheckBoxMenuItem`はチェックアイコンとは別のアイコンが設定されるので、`UIManager.put("CheckBoxMenuItem.checkIcon", icon);`を使用しています。

### 参考リンク
- [JRadioButtonMenuItemのチェックアイコンを変更する](http://terai.xrea.jp/Swing/RadioButtonMenuItemIcon.html)

<!-- dummy comment line for breaking list -->

### コメント
- `NimbusLookAndFeel`などの場合 -- [aterai](http://terai.xrea.jp/aterai.html) 2009-11-20 (金) 13:54:08

<!-- dummy comment line for breaking list -->

<pre class="prettyprint"><code>import java.awt.*;
import java.awt.geom.*;
import javax.swing.*;
// JDK 1.6
import com.sun.java.swing.*;
import com.sun.java.swing.plaf.nimbus.*;
// JDK 1.7
//import javax.swing.plaf.nimbus.*;

class NimbusCheckIconTest {
  public JMenuBar createMenuBar() {
    JCheckBoxMenuItem cbmi = new JCheckBoxMenuItem("checkIcon test");
    UIDefaults d = new UIDefaults();
    d.put("CheckBoxMenuItem[Enabled].checkIconPainter",
        new MyCheckBoxMenuItemPainter(
            MyCheckBoxMenuItemPainter.CHECKICON_ENABLED));
    d.put("CheckBoxMenuItem[MouseOver].checkIconPainter",
        new MyCheckBoxMenuItemPainter(
            MyCheckBoxMenuItemPainter.CHECKICON_MOUSEOVER));
    d.put("CheckBoxMenuItem[Enabled+Selected].checkIconPainter",
        new MyCheckBoxMenuItemPainter(
            MyCheckBoxMenuItemPainter.CHECKICON_ENABLED_SELECTED));
    d.put("CheckBoxMenuItem[MouseOver+Selected].checkIconPainter",
        new MyCheckBoxMenuItemPainter(
            MyCheckBoxMenuItemPainter.CHECKICON_SELECTED_MOUSEOVER));
    cbmi.putClientProperty("Nimbus.Overrides", d);
    cbmi.putClientProperty("Nimbus.Overrides.InheritDefaults", false);
    JMenuBar menuBar = new JMenuBar();
    JMenu menu = new JMenu("A Menu");
    menuBar.add(menu);
    menu.add(new JCheckBoxMenuItem("default"));
    menu.add(cbmi);
    menuBar.add(menu);
    return menuBar;
  }
  public Container createContentPane() {
    JPanel contentPane = new JPanel(new BorderLayout());
    contentPane.setOpaque(true);
    contentPane.add(new JScrollPane(new JTextArea()));
    return contentPane;
  }
  private static void createAndShowGUI() {
    try{
      for(UIManager.LookAndFeelInfo laf: UIManager.getInstalledLookAndFeels())
        if("Nimbus".equals(laf.getName()))
          UIManager.setLookAndFeel(laf.getClassName());
    }catch(Exception e) {
      e.printStackTrace();
    }
    NimbusCheckIconTest demo = new NimbusCheckIconTest();
    JFrame f = new JFrame();
    f.setDefaultCloseOperation(JFrame.EXIT_ON_CLOSE);
    f.setJMenuBar(demo.createMenuBar());
    f.setContentPane(demo.createContentPane());
    f.setSize(320, 240);
    f.setLocationRelativeTo(null);
    f.setVisible(true);
  }
  public static void main(String[] args) {
    EventQueue.invokeLater(new Runnable() {
      @Override public void run() { createAndShowGUI(); }
    });
  }
}
//copy: CheckBoxMenuItemPainter.java
class MyCheckBoxMenuItemPainter extends AbstractRegionPainter {
  static final int CHECKICON_ENABLED_SELECTED   = 6;
  static final int CHECKICON_SELECTED_MOUSEOVER = 7;
  static final int CHECKICON_ENABLED            = 8;
  static final int CHECKICON_MOUSEOVER          = 9;
  private int state;
  private PaintContext ctx;
  public MyCheckBoxMenuItemPainter(int state) {
    super();
    this.state = state;
    this.ctx = new AbstractRegionPainter.PaintContext(
      new Insets(5, 5, 5, 5), new Dimension(9, 10), false, null, 1.0, 1.0);
  }
  @Override protected void doPaint(Graphics2D g, JComponent c,
               int width, int height, Object[] eckey) {
    switch(state) {
      case CHECKICON_ENABLED:
        paintcheckIconEnabled(g);              break;
      case CHECKICON_MOUSEOVER:
        paintcheckIconMouseOver(g);            break;
      case CHECKICON_ENABLED_SELECTED:
        paintcheckIconEnabledAndSelected(g);   break;
      case CHECKICON_SELECTED_MOUSEOVER:
        paintcheckIconSelectedAndMouseOver(g); break;
    }
  }
  @Override protected final PaintContext getPaintContext() {
    return ctx;
  }
  private void paintcheckIconEnabled(Graphics2D g) {
      g.setPaint(Color.GREEN);
      g.drawOval( 0, 0, 10, 10 );
  }
  private void paintcheckIconMouseOver(Graphics2D g) {
      g.setPaint(Color.PINK);
      g.drawOval( 0, 0, 10, 10 );
  }
  private void paintcheckIconEnabledAndSelected(Graphics2D g) {
    g.setPaint(Color.ORANGE);
    g.fillOval( 0, 0, 10, 10 );
  }
  private void paintcheckIconSelectedAndMouseOver(Graphics2D g) {
    g.setPaint(Color.CYAN);
    g.fillOval( 0, 0, 10, 10 );
  }
}
</code></pre>

