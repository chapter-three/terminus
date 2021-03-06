<?php

namespace Pantheon\Terminus\Commands\Import;

use Pantheon\Terminus\Commands\TerminusCommand;
use Pantheon\Terminus\Site\SiteAwareInterface;
use Pantheon\Terminus\Site\SiteAwareTrait;
use Pantheon\Terminus\Exceptions\TerminusException;

/**
 * Class SiteCommand
 * @package Pantheon\Terminus\Commands\Import
 */
class SiteCommand extends TerminusCommand implements SiteAwareInterface
{
    use SiteAwareTrait;

    /**
     *  Imports a site archive (code, database, and files) to the site.
     *
     * @authorize
     *
     * @command import:site
     * @aliases site:import
     *
     * @option string $site Site name
     * @option string $url Publicly accessible URL of the site archive
     *
     * @usage <site> <archive_url> Imports the site archive at <archive_url> to <site>.
     */
    public function import($sitename, $url)
    {
        $site = $sitename;
        list($site, $env) = $this->getSiteEnv($site, 'dev');

        $tr = ['site' => $site->getName(), 'env' => $env->getName()];
        if (!$this->confirm('Are you sure you overwrite the code, database and files for {env} on {site}?', $tr)) {
            return;
        }

        $workflow = $env->import($url);
        try {
            while (!$workflow->checkProgress()) {
                // @TODO: Add Symfony progress bar to indicate that something is happening.
            }
        } catch (\Exception $e) {
            if ($e->getMessage() == 'Successfully queued import_site') {
                throw new TerminusException('Site import failed');
            }
            throw $e;
        }
        $this->log()->notice('Imported site onto Pantheon');
    }
}
