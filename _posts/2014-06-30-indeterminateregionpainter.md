---
layout: post
title: JProgressBarのNimbusLookAndFeelにおける不確定状態アニメーションを変更する
category: swing
folder: IndeterminateRegionPainter
tags: [JProgressBar, UIDefaults, Painter, NimbusLookAndFeel]
author: aterai
comments: true
---

Posted by [aterai](http://terai.xrea.jp/aterai.html) at 2014-06-30

## JProgressBarのNimbusLookAndFeelにおける不確定状態アニメーションを変更する
`JProgressBar`を`NimbusLookAndFeel`で使用している場合、その不確定状態アニメーションを変更します。

{% download %}

![screenshot](https://lh5.googleusercontent.com/-L28C52EISs4/U7AofjsiWqI/AAAAAAAACIo/OHDDAqKKk6E/s800/IndeterminateRegionPainter.png)

### サンプルコード
<pre class="prettyprint"><code>UIDefaults d = new UIDefaults();
d.put("ProgressBar[Enabled+Indeterminate].foregroundPainter", new AbstractRegionPainter() {
  //...
  private final PaintContext ctx = new PaintContext(
      new Insets(5, 5, 5, 5), new Dimension(29, 19), false);
  @Override public void doPaint(
      Graphics2D g, JComponent c, int width, int height, Object[] extendedCacheKeys) {
    path = decodePath1();
    g.setPaint(color17);
    g.fill(path);
    rect = decodeRect3();
    g.setPaint(decodeGradient5(rect));
    g.fill(rect);
    rect = decodeRect4();
    g.setPaint(decodeGradient6(rect));
    g.fill(rect);
  }
  @Override public PaintContext getPaintContext() {
    return ctx;
  }
  //...
});
progressBar1 = new JProgressBar(model);
progressBar1.putClientProperty("Nimbus.Overrides", d);
</code></pre>

### 解説
上記のサンプルでは、`NimbusLookAndFeel`で`JProgressBar`の不確定状態アニメーションを変更するために、セルの描画を行う`AbstractRegionPainter#doPaint(...)`をオーバーライドし、これを`UIDefaults`に設定しています。

- - - -
- テスト: `BasicLookAndFeel`の場合のサンプル

<!-- dummy comment line for breaking list -->

<pre class="prettyprint"><code>//package example;
//-*- mode:java; encoding:utf-8 -*-
// vim:set fileencoding=utf-8:
//@homepage@
import java.awt.*;
import java.awt.event.*;
import java.awt.geom.*;
import java.beans.*;
import javax.swing.*;
import javax.swing.plaf.basic.*;
import javax.swing.plaf.nimbus.*;

public final class StripedProgressBar extends JPanel implements HierarchyListener {
  private final BoundedRangeModel model = new DefaultBoundedRangeModel();
  private final JProgressBar progressBar0 = new JProgressBar(model);
  private final JProgressBar progressBar1;
  private SwingWorker&lt;String, Void&gt; worker;
  public StripedProgressBar() {
    super(new BorderLayout());
    UIManager.put("ProgressBar.cycleTime", 1000);
    UIManager.put("ProgressBar.repaintInterval", 10);

    progressBar0.setUI(new BasicProgressBarUI() {
      @Override protected int getBoxLength(int availableLength, int otherDimension) {
        return availableLength; //(int)Math.round(availableLength/6.0);
      }
      @Override public void paintIndeterminate(Graphics g, JComponent c) {
        if (!(g instanceof Graphics2D)) {
          return;
        }

        Insets b = progressBar.getInsets(); // area for border
        int barRectWidth  = progressBar.getWidth() - b.right - b.left;
        int barRectHeight = progressBar.getHeight() - b.top - b.bottom;

        if (barRectWidth &lt;= 0 || barRectHeight &lt;= 0) {
          return;
        }

        Graphics2D g2 = (Graphics2D) g;
        g2.setRenderingHint(RenderingHints.KEY_ANTIALIASING,
                            RenderingHints.VALUE_ANTIALIAS_ON);

        // Paint the bouncing box.
        boxRect = getBox(boxRect);
        if (boxRect != null) {
          int w = 10;
          int x = getAnimationIndex();
          GeneralPath p = new GeneralPath();
          p.moveTo(boxRect.x,           boxRect.y);
          p.lineTo(boxRect.x + w * .5f, boxRect.y + boxRect.height);
          p.lineTo(boxRect.x + w,       boxRect.y + boxRect.height);
          p.lineTo(boxRect.x + w * .5f, boxRect.y);
          p.closePath();
          g2.setColor(progressBar.getForeground());
          AffineTransform at = AffineTransform.getTranslateInstance(x, 0);
          for (int i = -x; i &lt; boxRect.width; i += w) {
            g2.fill(AffineTransform.getTranslateInstance(i, 0).createTransformedShape(p));
          }
        }
      }
    });

      
    progressBar1 = new JProgressBar(model);
    progressBar1.setUI(new BasicProgressBarUI() {
      @Override protected int getBoxLength(int availableLength, int otherDimension) {
        return availableLength; //(int)Math.round(availableLength/6.0);
      }
      @Override public void paintIndeterminate(Graphics g, JComponent c) {
        if (!(g instanceof Graphics2D)) {
          return;
        }

        Insets b = progressBar.getInsets(); // area for border
        int barRectWidth  = progressBar.getWidth() - b.right - b.left;
        int barRectHeight = progressBar.getHeight() - b.top - b.bottom;

        if (barRectWidth &lt;= 0 || barRectHeight &lt;= 0) {
          return;
        }

        Graphics2D g2 = (Graphics2D) g;
        g2.setRenderingHint(RenderingHints.KEY_ANTIALIASING,
                            RenderingHints.VALUE_ANTIALIAS_ON);

        // Paint the bouncing box.
        boxRect = getBox(boxRect);
        if (boxRect != null) {
          int w = 10;
          int x = getAnimationIndex();
          GeneralPath p = new GeneralPath();
          p.moveTo(boxRect.x,           boxRect.y + boxRect.height);
          p.lineTo(boxRect.x + w * .5f, boxRect.y + boxRect.height);
          p.lineTo(boxRect.x + w,       boxRect.y);
          p.lineTo(boxRect.x + w * .5f, boxRect.y);
          p.closePath();
          g2.setColor(progressBar.getForeground());
          AffineTransform at = AffineTransform.getTranslateInstance(x, 0);
          for (int i = boxRect.width + x; i &gt; -w; i -= w) {
            g2.fill(AffineTransform.getTranslateInstance(i, 0).createTransformedShape(p));
          }
        }
      }
    });

    JPanel p = new JPanel(new GridLayout(2, 1));
    p.add(makeTitlePanel("Default", progressBar0));
    p.add(makeTitlePanel("ProgressBar[Indeterminate].foregroundPainter", progressBar1));

    Box box = Box.createHorizontalBox();
    box.add(Box.createHorizontalGlue());
    box.add(new JButton(new AbstractAction("Test start") {
      @Override public void actionPerformed(ActionEvent e) {
        if (worker != null &amp;&amp; !worker.isDone()) {
          worker.cancel(true);
        }
        progressBar0.setIndeterminate(true);
        progressBar1.setIndeterminate(true);
        worker = new Task();
        worker.addPropertyChangeListener(new ProgressListener(progressBar0));
        worker.addPropertyChangeListener(new ProgressListener(progressBar1));
        worker.execute();
      }
    }));
    box.add(Box.createHorizontalStrut(5));

    addHierarchyListener(this);
    add(p);
    add(box, BorderLayout.SOUTH);
    setBorder(BorderFactory.createEmptyBorder(5, 5, 5, 5));
    setPreferredSize(new Dimension(320, 240));
  }
  @Override public void hierarchyChanged(HierarchyEvent he) {
    JComponent c = (JComponent) he.getComponent();
    if ((he.getChangeFlags() &amp; HierarchyEvent.DISPLAYABILITY_CHANGED) != 0 &amp;&amp; !c.isDisplayable() &amp;&amp; worker != null) {
      System.out.println("DISPOSE_ON_CLOSE");
      worker.cancel(true);
      worker = null;
    }
  }

  private static JComponent makeTitlePanel(String title, JComponent cmp) {
    JPanel p = new JPanel(new GridBagLayout());
    p.setBorder(BorderFactory.createTitledBorder(title));
    GridBagConstraints c = new GridBagConstraints();
    c.fill    = GridBagConstraints.HORIZONTAL;
    c.insets  = new Insets(5, 5, 5, 5);
    c.weightx = 1.0;
    c.gridy   = 0;
    p.add(cmp, c);
    return p;
  }
  public static void main(String[] args) {
    EventQueue.invokeLater(new Runnable() {
      @Override public void run() {
        createAndShowGUI();
      }
    });
  }
  public static void createAndShowGUI() {
    JFrame frame = new JFrame("@title@");
    frame.setDefaultCloseOperation(WindowConstants.DISPOSE_ON_CLOSE);
    //frame.setDefaultCloseOperation(WindowConstants.EXIT_ON_CLOSE);
    frame.getContentPane().add(new StripedProgressBar());
    frame.pack();
    frame.setLocationRelativeTo(null);
    frame.setVisible(true);
  }
}

class Task extends SwingWorker&lt;String, Void&gt; {
  @Override public String doInBackground() {
    try { // dummy task
      Thread.sleep(5000);
    } catch (InterruptedException ie) {
      return "Interrupted";
    }
    int current = 0;
    int lengthOfTask = 100;
    while (current &lt;= lengthOfTask &amp;&amp; !isCancelled()) {
      try { // dummy task
        Thread.sleep(50);
      } catch (InterruptedException ie) {
        return "Interrupted";
      }
      setProgress(100 * current / lengthOfTask);
      current++;
    }
    return "Done";
  }
}

class ProgressListener implements PropertyChangeListener {
  private final JProgressBar progressBar;
  public ProgressListener(JProgressBar progressBar) {
    this.progressBar = progressBar;
    this.progressBar.setValue(0);
  }
  @Override public void propertyChange(PropertyChangeEvent evt) {
    String strPropertyName = evt.getPropertyName();
    if ("progress".equals(strPropertyName)) {
      progressBar.setIndeterminate(false);
      int progress = (Integer) evt.getNewValue();
      progressBar.setValue(progress);
    }
  }
}
</code></pre>

### コメント
