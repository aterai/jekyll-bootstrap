---
layout: post
title: JDialogでモーダルなJProgressBar付きSplash Screenを表示する
category: swing
folder: ProgressSplashScreen
tags: [JDialog, JProgressBar, SwingWorker, ModalityType]
author: aterai
---

Posted by [aterai](http://terai.xrea.jp/aterai.html) at 2009-11-09

## JDialogでモーダルなJProgressBar付きSplash Screenを表示する
`JDialog`でモーダルな`JProgressBar`付き`Splash Screen`を表示します。

- {% jnlp %}
- {% jar %}
- {% src %}
- {% svn %}

<!-- dummy comment line for breaking list -->

![screenshot](http://lh5.ggpht.com/_9Z4BYR88imo/TQTRSxG9iaI/AAAAAAAAAg8/Wpd3hycacS4/s800/ProgressSplashScreen.png)

### サンプルコード
<pre class="prettyprint"><code>final JFrame frame = new JFrame();
final JDialog splashScreen  = new JDialog(frame, Dialog.ModalityType.DOCUMENT_MODAL);
final JProgressBar progress = new JProgressBar();
EventQueue.invokeLater(new Runnable() {
  @Override public void run() {
    splashScreen.setUndecorated(true);
    splashScreen.getContentPane().add(
      new JLabel(new ImageIcon(getClass().getResource("splash.png"))));
    splashScreen.getContentPane().add(progress, BorderLayout.SOUTH);
    splashScreen.pack();
    splashScreen.setLocationRelativeTo(null);
    splashScreen.setVisible(true);
  }
});
SwingWorker&lt;Void,Void&gt; worker = new SwingWorker&lt;Void,Void&gt;() {
  @Override public Void doInBackground() {
    try{
      int current = 0;
      int lengthOfTask = 120;
      while(current&lt;lengthOfTask &amp;&amp; !isCancelled()) {
        try {
          Thread.sleep(50);
        }catch(InterruptedException ie) {
          ie.printStackTrace();
          return null;
        }
        setProgress(100 * current++ / lengthOfTask);
      }
    }catch(Exception ex) {
      ex.printStackTrace();
    }
    return null;
  }
  @Override public void done() {
    splashScreen.dispose();
  }
};
worker.addPropertyChangeListener(new java.beans.PropertyChangeListener() {
  @Override public void propertyChange(java.beans.PropertyChangeEvent e) {
    if("progress".equals(e.getPropertyName())) {
      progress.setValue((Integer)e.getNewValue());
    }
  }
});
worker.execute();

frame.setDefaultCloseOperation(WindowConstants.EXIT_ON_CLOSE);
frame.getContentPane().add(new MainPanel());
frame.pack();
frame.setLocationRelativeTo(null);
EventQueue.invokeLater(new Runnable() {
  @Override public void run() {
    frame.setVisible(true);
  }
});
</code></pre>

### 解説
上記のサンプルでは、以下のようなスプラッシュスクリーンを表示しています。

- モーダルな`JDialog`に、画像と`JProgressBar`を追加
- `Dialog#setUndecorated(true)`として、タイトルバーを非表示
- `SwingWorker`を使って、進捗状態を表示

<!-- dummy comment line for breaking list -->

- - - -
`JTabbedPane`に順次タブを追加していくテスト

<pre class="prettyprint"><code>//package example;
//-*- mode:java; encoding:utf8n; coding:utf-8 -*-
// vim:set fileencoding=utf-8:
//@homepage@
import java.awt.*;
import java.beans.*;
import java.util.List;
import javax.swing.*;

public class ProgressSplashScreenTest {
  public static void main(String[] args) {
    EventQueue.invokeLater(new Runnable() {
      @Override public void run() {
        createAndShowGUI();
      }
    });
  }
  public static void createAndShowGUI() {
    final JFrame frame = new JFrame();
    final JDialog splashScreen  = new JDialog(
      frame, Dialog.ModalityType.DOCUMENT_MODAL);
    final JProgressBar progress = new JProgressBar();
    final JTabbedPane tabbedPane = new JTabbedPane();
    frame.setDefaultCloseOperation(WindowConstants.EXIT_ON_CLOSE);
    frame.getContentPane().add(tabbedPane);
    progress.setStringPainted(true);

    EventQueue.invokeLater(new Runnable() {
      @Override public void run() {
        splashScreen.setUndecorated(true);
        splashScreen.getContentPane().add(
            new JLabel(new SplashScreenIcon()));
        splashScreen.getContentPane().add(progress, BorderLayout.SOUTH);
        splashScreen.pack();
        splashScreen.setLocationRelativeTo(null);
        splashScreen.setVisible(true);
      }
    });

    SwingWorker&lt;Void,String&gt; worker = new SwingWorker&lt;Void,String&gt;() {
      @Override public Void doInBackground() {
        try {
          int current = 0;
          int lengthOfTask = 120;
          while(current&lt;=lengthOfTask &amp;&amp; !isCancelled()) {
            try {
              Thread.sleep(50); //dummy
            } catch(InterruptedException ie) {
              ie.printStackTrace();
              return null;
            }
            if(current == 20) {
              publish("showFrame");
            } else if(current%24==0) {
              publish("title: "+current);
            }
            setProgress(100 * current++ / lengthOfTask);
          }
        } catch(Exception ex) {
          ex.printStackTrace();
        }
        return null;
      }
      @Override protected void process(List&lt;String&gt; chunks) {
        for(String cmd : chunks) {
          if(cmd.equals("showFrame")) {
            frame.setSize(512, 320);
            frame.setLocationRelativeTo(null);
            frame.setVisible(true);
          } else {
            tabbedPane.addTab(cmd, new JLabel(cmd));
            tabbedPane.setSelectedIndex(tabbedPane.getTabCount()-1);
            progress.setString("Loading: "+cmd);
          }
        }
      }
      @Override public void done() {
        splashScreen.dispose();
      }
    };
    worker.addPropertyChangeListener(new PropertyChangeListener() {
      @Override public void propertyChange(PropertyChangeEvent e) {
        if("progress".equals(e.getPropertyName())) {
          progress.setValue((Integer)e.getNewValue());
        }
      }
    });
    worker.execute();
  }
}
class SplashScreenIcon implements Icon {
  @Override public void paintIcon(Component c, Graphics g, int x, int y) {
    Graphics2D g2 = (Graphics2D)g.create();
    g2.translate(x, y);
    g2.setPaint(Color.GREEN);
    g2.fillRect(10,10,180,80);
    g2.translate(-x,-y);
    g2.dispose();
  }
  @Override public int getIconWidth()  {
    return 200;
  }
  @Override public int getIconHeight() {
    return 100;
  }
}
</code></pre>

### 参考リンク
- [JWindowを使ったSplash Screenの表示](http://terai.xrea.jp/Swing/SplashScreen.html)

<!-- dummy comment line for breaking list -->

### コメント