---
layout: post
title: JPopupMenuをボタンの長押しで表示
category: swing
folder: PressAndHoldButton
tags: [JToolBar, JButton, JPopupMenu, MouseListener, GridLayout]
author: aterai
comments: true
---

Posted by [aterai](http://terai.xrea.jp/aterai.html) at 2009-01-26

## JPopupMenuをボタンの長押しで表示
`JToolBar`に、長押しで`JPopupMenu`、クリックで選択されたメニューを表示するボタンを追加します。

{% download %}

![screenshot](https://lh4.googleusercontent.com/_9Z4BYR88imo/TQTRIzHMLNI/AAAAAAAAAgs/0_PwsyZOl-I/s800/PressAndHoldButton.png)

### サンプルコード
<pre class="prettyprint"><code>private class ArrowButtonHandler extends AbstractAction implements MouseListener {
  private final javax.swing.Timer autoRepeatTimer;
  private AbstractButton arrowButton = null;
  public ArrowButtonHandler() {
    autoRepeatTimer = new javax.swing.Timer(1000, new ActionListener() {
      @Override public void actionPerformed(ActionEvent e) {
        System.out.println("InitialDelay(1000)");
        if(arrowButton!=null &amp;&amp; arrowButton.getModel().isPressed()
                             &amp;&amp; autoRepeatTimer.isRunning()) {
          autoRepeatTimer.stop();
          pop.show(arrowButton, 0, arrowButton.getHeight());
          pop.requestFocusInWindow();
        }
      }
    });
    autoRepeatTimer.setInitialDelay(1000);
    pop.addPopupMenuListener(new PopupMenuListener() {
      @Override public void popupMenuCanceled(PopupMenuEvent e) {}
      @Override public void popupMenuWillBecomeVisible(PopupMenuEvent e) {}
      @Override public void popupMenuWillBecomeInvisible(PopupMenuEvent e) {
        if(arrowButton!=null) {
          arrowButton.setSelected(false);
        }
      }
    });
  }
  @Override public void actionPerformed(ActionEvent e) {
    if(autoRepeatTimer.isRunning()) {
      System.out.println("actionPerformed");
      System.out.println("  "+bg.getSelection().getActionCommand());
      if(arrowButton!=null) arrowButton.setSelected(false);
      autoRepeatTimer.stop();
    }
  }
  @Override public void mousePressed(MouseEvent e) {
    System.out.println("mousePressed");
    if(SwingUtilities.isLeftMouseButton(e) &amp;&amp; e.getComponent().isEnabled()) {
      arrowButton = (AbstractButton)e.getSource();
      autoRepeatTimer.start();
    }
  }
  @Override public void mouseReleased(MouseEvent e) {
    autoRepeatTimer.stop();
  }
  @Override public void mouseExited(MouseEvent e) {
    if(autoRepeatTimer.isRunning()) {
      autoRepeatTimer.stop();
    }
  }
  @Override public void mouseEntered(MouseEvent e) {}
  @Override public void mouseClicked(MouseEvent e) {}
}
</code></pre>

### 解説
上記のサンプルでは、`1000`ミリ秒ボタンを押したままにしておくと、`JRadioButton`を配置した`JPopupMenu`を表示します。普通にクリックした場合は、現在選択されている`JRadioButton`の色をコンソールに出力するようになっています。

- - - -
`JPopupMenu`のレイアウトを`pop.setLayout(new GridLayout(0,3));`で変更し、三列に`JRadioButton`を並べています。

### コメント
