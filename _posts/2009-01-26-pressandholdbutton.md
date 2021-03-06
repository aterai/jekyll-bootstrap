---
layout: post
category: swing
folder: PressAndHoldButton
title: JPopupMenuをボタンの長押しで表示
tags: [JToolBar, JButton, JPopupMenu, MouseListener, GridLayout, Timer]
author: aterai
pubdate: 2009-01-26T13:29:29+09:00
description: JToolBarに、長押しでJPopupMenu、クリックで選択されたメニューを表示するボタンを追加します。
image: https://lh4.googleusercontent.com/_9Z4BYR88imo/TQTRIzHMLNI/AAAAAAAAAgs/0_PwsyZOl-I/s800/PressAndHoldButton.png
hreflang:
    href: https://java-swing-tips.blogspot.com/2014/03/long-pressing-jbutton-to-get-jpopupmenu.html
    lang: en
comments: true
---
## 概要
`JToolBar`に、長押しで`JPopupMenu`、クリックで選択されたメニューを表示するボタンを追加します。

{% download https://lh4.googleusercontent.com/_9Z4BYR88imo/TQTRIzHMLNI/AAAAAAAAAgs/0_PwsyZOl-I/s800/PressAndHoldButton.png %}

## サンプルコード
<pre class="prettyprint"><code>class PressAndHoldHandler extends AbstractAction implements MouseListener {
  public final JPopupMenu pop = new JPopupMenu();
  public final ButtonGroup bg = new ButtonGroup();
  private AbstractButton arrowButton;
  private final Timer holdTimer = new Timer(1000, new ActionListener() {
    @Override public void actionPerformed(ActionEvent e) {
      System.out.println("InitialDelay(1000)");
      if (arrowButton != null &amp;&amp; arrowButton.getModel().isPressed()
          &amp;&amp; holdTimer.isRunning()) {
        holdTimer.stop();
        pop.show(arrowButton, 0, arrowButton.getHeight());
        pop.requestFocusInWindow();
      }
    }
  });
  public PressAndHoldHandler() {
    super();
    holdTimer.setInitialDelay(1000);
    pop.setLayout(new GridLayout(0, 3, 5, 5));
    for (MenuContext m: makeMenuList()) {
      AbstractButton b = new JRadioButton(m.command);
      b.setActionCommand(m.command);
      b.setForeground(m.color);
      b.setBorder(BorderFactory.createEmptyBorder());
      b.addActionListener(new ActionListener() {
        @Override public void actionPerformed(ActionEvent e) {
          System.out.println(bg.getSelection().getActionCommand());
          pop.setVisible(false);
        }
      });
      pop.add(b);
      bg.add(b);
    }
  }
  private List&lt;MenuContext&gt; makeMenuList() {
    return Arrays.asList(
      new MenuContext("BLACK", Color.BLACK),
      new MenuContext("BLUE", Color.BLUE),
      new MenuContext("CYAN", Color.CYAN),
      new MenuContext("GREEN", Color.GREEN),
      new MenuContext("MAGENTA", Color.MAGENTA),
      new MenuContext("ORANGE", Color.ORANGE),
      new MenuContext("PINK", Color.PINK),
      new MenuContext("RED", Color.RED),
      new MenuContext("YELLOW", Color.YELLOW));
  }
  @Override public void actionPerformed(ActionEvent e) {
    System.out.println("actionPerformed");
    if (holdTimer.isRunning()) {
      ButtonModel model = bg.getSelection();
      if (model != null) {
        System.out.println(model.getActionCommand());
      }
      holdTimer.stop();
    }
  }
  @Override public void mousePressed(MouseEvent e) {
    System.out.println("mousePressed");
    Component c = e.getComponent();
    if (SwingUtilities.isLeftMouseButton(e) &amp;&amp; c.isEnabled()) {
      arrowButton = (AbstractButton) c;
      holdTimer.start();
    }
  }
  @Override public void mouseReleased(MouseEvent e) {
    holdTimer.stop();
  }
  @Override public void mouseExited(MouseEvent e) {
    if (holdTimer.isRunning()) {
      holdTimer.stop();
    }
  }
  @Override public void mouseEntered(MouseEvent e) { /* not needed */ }
  @Override public void mouseClicked(MouseEvent e) { /* not needed */ }
}
</code></pre>

## 解説
- 長押し
    - ボタンクリックが`1000`ミリ秒以上継続すると`JRadioButton`を配置した`JPopupMenu`を表示
        - `JPopupMenu`のレイアウトを`pop.setLayout(new GridLayout(0, 3))`で変更し`JRadioButton`を`3`列並べて表示
- シングルクリック
    - 現在選択されている`JRadioButton`の色をコンソールに出力

<!-- dummy comment line for breaking list -->

## 参考リンク
- [Timer#setInitialDelay(...) (Java Platform SE 8)](https://docs.oracle.com/javase/jp/8/docs/api/javax/swing/Timer.html#setInitialDelay-int-)

<!-- dummy comment line for breaking list -->

## コメント
